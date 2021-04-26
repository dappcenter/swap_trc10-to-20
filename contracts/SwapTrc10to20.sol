pragma solidity ^0.5.8;

import "./Address.sol";
import "./SafeMath.sol";
import "./ITRC20.sol";
import "./Ownable.sol";

/*
 * @title SwapTrc10to20
 * Author: Paul Pironmind | pironmind@gmail.com
 * Licence: MIT
 */
contract SwapTrc10to20 is Ownable {
    using Address for address;
    using SafeMath for uint;

    uint public trc10id;
    ITRC20 public trc20;

    uint8 trc10decimal;
    uint8 trc20decimal;

    uint public rate = 1;
    bool public ratePositive = false;

    mapping(address => uint) private _trc10balance;
    mapping(address => uint) private _trc20balance;

    constructor(
        uint _trc10,
        address _trc20,
        uint8 _trc10dec,
        uint8 _trc20dec
    )
        public
        Ownable(msg.sender)
    {
        trc10id = _trc10;
        trc20 = ITRC20(_trc20);
        trc10decimal = _trc10dec;
        trc20decimal = _trc20dec;
    }

    function getTRC10Balance(address who) public view returns (uint) {
        return uint(_trc10balance[who]);
    }

    function getTRC20Balance(address who) public view returns (uint) {
        return uint(_trc20balance[who]);
    }

    function getTRC10ContractBalance() public view returns (uint) {
        trcToken id = trc10id;

        return uint(address(this).tokenBalance(id));
    }

    function getTRC20ContractBalance() public view returns (uint) {
        return uint(trc20.balanceOf(address(this)));
    }

    function flashSwap() public returns(bool) {
        trcToken id = msg.tokenid;
        uint256 value = msg.tokenvalue;

        require(uint(id) == trc10id, "Not valid token");

        _trc10balance[msg.sender] = _trc10balance[msg.sender].add(value);

        uint balanceBefore = _trc10balance[msg.sender];
        uint balanceAfter = _withRate(balanceBefore.mul(10**6))
            .mul(10**uint(trc20decimal))
            .div(10**uint(trc10decimal))
            .div(10**6);

        _trc10balance[msg.sender] = _trc10balance[msg.sender].sub(balanceBefore);
        _trc20balance[msg.sender] = _trc20balance[msg.sender].add(balanceAfter);

        uint _amount = _trc20balance[msg.sender];
        _trc20balance[msg.sender] = _trc20balance[msg.sender].sub(_amount);

        require(_amount > 0, "User has withdraw zero balance.");

        return trc20.transfer(Address.toPayable(msg.sender), _amount);
    }

    function setExchangeRate(uint value, bool positive) public onlyOwner returns (bool) {
        rate = value;
        ratePositive = positive;

        return true;
    }

    /*
     * @dev Withdraw basic TRC10 token to owner
     */
    function WDRL_Trc10ToOwner() public onlyOwner {
        return Address.toPayable(owner()).transferToken(getTRC10ContractBalance(), uint(trc10id));
    }

    /*
     * @dev Withdraw any TRC10 token to owner
     */
    function WDRL_AnyTrc10AnyToOwner(uint id) public onlyOwner {
        return Address.toPayable(owner()).transferToken(getTRC10ContractBalance(), uint(id));
    }

    /*
     * @dev Withdraw any ERC20 token to owner
     */
    function WDRL_AnyTrc20ToOwner(ITRC20 token) public onlyOwner returns (bool) {
        return token.transfer(Address.toPayable(owner()), getTRC20ContractBalance());
    }

    function _withRate(uint amount) private view returns (uint) {
        if (ratePositive) {
            return amount.mul(rate);
        }
        return amount.div(rate);
    }
}
