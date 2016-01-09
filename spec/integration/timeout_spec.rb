require 'spec_helper'

describe "Preforker", :integration do
  it "should not respawn workers when there's not a timeout" do
    run_preforker <<-CODE
      Preforker.new(:timeout => 2, :workers => 1) do |master|
        sleep 0.1 while master.wants_me_alive?
      end.start
    CODE

    sleep 0.3
    term_server
    log = File.read("preforker.log")
    expect(log).not_to match(/ERROR.*timeout/)
    expect(log.scan(/Child.*Created/).size).to eq(1)
  end

  it "should respawn workers when there's a timeout (master checks once a second max)" do
    run_preforker <<-CODE
      Preforker.new(:timeout => 1, :workers => 1) do
        sleep 1000
      end.start
    CODE

    sleep 3
    term_server
    log = File.read("preforker.log")
    expect(log).to match(/ERROR.*timeout/)
    expect(log.scan(/Child.*Created/).size).to be > 1
  end
end
