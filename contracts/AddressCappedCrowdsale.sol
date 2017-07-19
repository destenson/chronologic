pragma solidity ^0.4.11;

import "./Crowdsale.sol";
import "./MintableToken.sol";

/**
 * ICO crowdsale contract that is capped by Number of addresses (investors).
 *
 * - Tokens are dynamically created during the crowdsale
 *
 *
 */
contract AddressCappedCrowdsale is Crowdsale {

    /* Maximum amount of wei this crowdsale can raise. */
    uint public weiCap;
    uint maxIcoAddresses;

    function AddressCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _weiCap, uint _preMinWei, uint _preMaxWei, uint _minWei, uint _maxWei, uint _maxPreAddresses, uint _maxIcoAddresses) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _preMinWei, _preMaxWei,  _minWei,  _maxWei,  _maxPreAddresses) {
        weiCap = _weiCap;
        maxIcoAddresses = _maxIcoAddresses;
    }
        /**
    * Called from invest() to confirm if the curret investment does not break our cap rule.
    */
    function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
        return weiRaisedTotal > weiCap;
    }

    function isCrowdsaleFull() public constant returns (bool) {
        return latestContributerId > maxIcoAddresses;
    }

    /**
    * Dynamically create tokens and assign them to the investor.
    */
    function assignTokens(address receiver, uint tokenAmount) private {
        MintableToken mintableToken = MintableToken(token);
        mintableToken.mint(receiver, tokenAmount);
    }
}