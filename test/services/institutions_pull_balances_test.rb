require "test_helper"

class Institutions::PullBalancesTest < ActiveSupport::TestCase
  def setup
    @institution = institutions(:one) # Assuming a fixture or factory for an Institution exists
    @pull_balances = Institutions::PullBalances.new(@institution)
  end

  test "calls validate! method" do
    plaid_account_1 = OpenStruct.new(
      account_id: "account_id_1",
      type: "depository",
      name: "checking",
      subtype: "checking",
      balances: OpenStruct.new(current: 1000, available: 1000, iso_currency_code: "USD")
    )
    plaid_account_2 = OpenStruct.new(
      account_id: "account_id_2",
      type: "credit",
      name: "credit card",
      subtype: "credit card",
      balances: OpenStruct.new(current: 1000, available: 1000, iso_currency_code: "USD")
    )

    @pull_balances.expects(:validate!).once
    @pull_balances.stubs(:fetch_accounts).returns([ plaid_account_1, plaid_account_2 ])
    # @pull_balances.stubs(:persist!).returns(nil)

    assert_difference "Account.count", +2 do
      assert_difference "BalanceSnapshot.count", +2 do
        @pull_balances.call
      end
    end
  end
end
