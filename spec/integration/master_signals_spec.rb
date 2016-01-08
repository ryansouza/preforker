require 'spec_helper'

describe "Preforker", :integration do
  it "should quit gracefully" do
    run_preforker <<-CODE
      Preforker.new(:workers => 1) do |master|
        sleep 0.1 while master.wants_me_alive?

        master.logger.info("Main loop ended. Dying")
      end.start
    CODE

    sleep 0.3
    quit_server
    log = File.read("preforker.log")
    expect(log).to match(/Main loop ended. Dying/)
  end

  it "shouldn't quit gracefully on term signal" do
    run_preforker <<-CODE
      Preforker.new(:workers => 1) do |master|
        sleep 0.1 while master.wants_me_alive?

        master.logger.info("Main loop ended. Dying")
      end.start
    CODE

    term_server
    log = File.read("preforker.log")
    expect(log).not_to match(/Main loop ended. Dying/)
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
    expect(log).not_to match(/Main loop ended. Dying/)
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
    expect(log.scan(/Child.*Created/).size).to eq(3)
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
    expect(log.scan(/Child.*Exiting/).size).to eq(1)
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
    expect(log.scan(/Child.*Exiting/).size).to eq(2)
  end

  it "should keep creating workers when they die" do
    run_preforker <<-CODE
      Preforker.new(:workers => 1, :timeout => 0.2) do |master|
      end.start
    CODE

    sleep 0.3
    log = File.read("preforker.log")
    expect(log.scan(/Child.*Created/).size).to be > 1
  end
end
