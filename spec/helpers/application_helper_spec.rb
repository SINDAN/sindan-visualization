require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, :type => :helper do
  describe "nl2br" do
    it "replace line break to br tag" do
      str = "hoge\nhoge"

      result = nl2br(str)

      expect(result).to eq("hoge<br />hoge")
    end

    it "replace line break to br tag with tag" do
      str = "hoge<hr />\nhoge"

      result = nl2br(str)

      expect(result).to eq("hoge<hr /><br />hoge")
    end
  end

  describe "hbr" do
    it "replace line break to br tag" do
      str = "hoge\nhoge"

      result = hbr(str)

      expect(result).to eq("hoge<br />hoge")
    end

    it "replace line break to br tag with tag" do
      str = "hoge<hr />\nhoge"

      result = hbr(str)

      expect(result).to eq("hoge&lt;hr /&gt;<br />hoge")
    end
  end
end
