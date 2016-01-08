require 'spec_helper'

describe "Preforker", :integration do
  it "should kill the master and workers after a quit signal" do
    run_preforker <<-CODE
      Preforker.new(:workers => 2) do |master|
        sleep 0.1 while master.wants_me_alive?

        master.logger.info("Main loop ended. Dying")
      end.start
    CODE

    quit_server
    `ps aux | grep Preforker | grep -v grep`.should == ""
  end

  it "should kill the master and workers after a term signal" do
    run_preforker <<-CODE
      Preforker.new(:workers => 2) do |master|
        sleep 0.1 while master.wants_me_alive?

        master.logger.info("Main loop ended. Dying")
      end.start
    CODE

    term_server
    `ps aux | grep Preforker | grep -v grep`.should == ""
  end

  it "should create a pid file" do
    run_preforker <<-CODE
      Preforker.new(:workers => 1) do
      end.start
    CODE

    File.exists?("preforker.pid").should == true
  end

  it "should delete the pid file after a quit signal" do
    run_preforker <<-CODE
      Preforker.new do |master|
        sleep 0.1 while master.wants_me_alive?
      end.start
    CODE

    quit_server
    File.exists?("preforker.pid").should == false
  end

  it "should delete the pid file after a term signal" do
    run_preforker <<-CODE
      Preforker.new do |master|
        sleep 0.1 while master.wants_me_alive?
      end.start
    CODE

    term_server
    File.exists?("preforker.pid").should == false
  end

  it "should gracefully end the worker code when receiving the quit signal" do
    run_preforker <<-CODE
      Preforker.new(:workers => 1) do |master|
        sleep 0.1 while master.wants_me_alive?

        master.logger.info("Main loop ended. Dying")
      end.start
    CODE

    sleep 0.3
    quit_server
    log = File.read("preforker.log")
    log.should =~ /Main loop ended. Dying/
  end

  it "should not gracefully end the worker code when receiving the term signal" do
    run_preforker <<-CODE
      Preforker.new(:workers => 1) do |master|
        sleep 0.1 while master.wants_me_alive?

        master.logger.info("Main loop ended. Dying")
      end.start
    CODE

    term_server
    log = File.read("preforker.log")
    log.should_not =~ /Main loop ended. Dying/
  end

  it "shouldn't quit gracefully on int signal" do
    run_preforker <<-CODE
      Preforker.new(:workers => 1) do |master|
        sleep 0.1 while master.wants_me_alive?

        master.logger.info("Main loop ended. Dying")
      end.start
    CODE

    int_server
    log = File.read("preforker.log")
    log.should_not =~ /Main loop ended. Dying/
  end

  it "should add a worker on ttin" do
    run_preforker <<-CODE
      Preforker.new(:workers => 2) do |master|
        sleep 0.1 while master.wants_me_alive?
      end.start
    CODE

    signal_server(:TTIN)
    sleep 0.5
    log = File.read("preforker.log")
    log.scan(/Child.*Created/).size.should == 3
  end

  it "should remove a worker on ttou" do
    run_preforker <<-CODE
      Preforker.new(:workers => 2) do |master|
        sleep 0.1 while master.wants_me_alive?
      end.start
    CODE

    sleep 0.2
    signal_server(:TTOU)
    sleep 0.2
    log = File.read("preforker.log")
    log.scan(/Child.*Exiting/).size.should == 1
  end

  it "should remove all workers on winch" do
    run_preforker <<-CODE
      Preforker.new(:workers => 2) do |master|
        sleep 0.1 while master.wants_me_alive?
      end.start
    CODE

    sleep 0.2
    signal_server(:WINCH)
    sleep 0.2
    log = File.read("preforker.log")
    log.scan(/Child.*Exiting/).size.should == 2
  end

  it "should keep creating workers when they die" do
    run_preforker <<-CODE
      Preforker.new(:workers => 1, :timeout => 0.2) do |master|
      end.start
    CODE

    sleep 0.3
    log = File.read("preforker.log")
    log.scan(/Child.*Created/).size.should > 1
  end
end
