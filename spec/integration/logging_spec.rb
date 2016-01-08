require 'spec_helper'

describe "Preforker", :integration do
  it "should redirect stdout" do
    run_preforker <<-CODE
      Preforker.new(:workers => 1, :stdout_path => 'test.log') do
        puts "hello"
        sleep 0.3 while master.wants_me_alive?
      end.start
    CODE

    quit_server
    expect(File.read("test.log")).to eq("hello\n")
  end

  it "should redirect stdout to the null device" do
    run_preforker <<-CODE
      Preforker.new(:workers => 1, :stdout_path => '/dev/null') do
        puts "hello"
        sleep 0.3 while master.wants_me_alive?
      end.start
    CODE

    quit_server
    expect(File.exists?("test.log")).to eq(false)
  end

  it "should redirect stderr" do
    run_preforker <<-CODE
      Preforker.new(:workers => 1, :stderr_path => 'test.log') do |master|
        warn "hello"
        sleep 0.3 while master.wants_me_alive?
      end.start
    CODE

    sleep 0.3
    quit_server
    expect(File.read("test.log")).to eq("hello\n")
  end

  it "should have a default logger file" do
    run_preforker <<-CODE
      Preforker.new(:workers => 1) do
        sleep 0.3 while master.wants_me_alive?
      end.start
    CODE

    quit_server
    expect(File.read("preforker.log")).to match(/Logfile created on/)
  end

  it "should be possible to use the same file for logging, stdout and stderr" do
    run_preforker <<-CODE
      Preforker.new(:workers => 1, :stdout_path => 'test.log', :stderr_path => 'test.log', :logger => Logger.new('test.log')) do
        puts "stdout string"
        warn "stderr string"
        sleep 0.3 while master.wants_me_alive?
      end.start
    CODE

    sleep 0.3
    quit_server
    log = File.read("test.log")
    expect(log).to match(/stdout string/)
    expect(log).to match(/stderr string/)
    expect(log).to match(/Logfile created on/)
  end
end
