pragma solidity ^0.5.8;

import "./SafeMath.sol";
import "./ITRC20.sol";
import "./Ownable.sol";

/*
 * @title SwapTrc10to20
 * Author: Paul Pironmind | pironmind@gmail.com
 * Licence: MIT
 */
contract SwapTrc10to20 is Ownable {
    using SafeMath for uint;

    trcToken public trc10id;
    ITRC20 public trc20;

    uint public rate = 100;
    uint public totalSwapTrc20;

    mapping(address => uint) private _trc10balance;
    mapping(address => uint) private _trc20balance;

    constructor(uint _trc10, address _trc20)
        public
        Ownable(msg.sender)
    {
        trc10id = _trc10;
        trc20 = ITRC20(_trc20);
    }

    /**
     * @dev Function to set minimum deposit value
     * @param value The amount of tokens in SOL.
     * @return A boolean that indicates if the operation was successful.
     */
    function setExchangeRate(uint value) public onlyOwner returns (bool) {
        rate = value;

        return true;
    }

    function getTRC10Balance(address who) public view returns (uint){
        return uint(_trc10balance[who]);
    }

    function getTRC20Balance(address who) public view returns (uint){
        return uint(_trc20balance[who]);
    }

    function getTRC10ContractBalance() public view returns (uint){
        trcToken id = trc10id;

        return uint(address(this).tokenBalance(id));
    }

    function getTRC20ContractBalance() public view returns (uint){
        return uint(trc20.balanceOf(address(this)));
    }

    function depositTrc10() public payable returns (bool) {
        trcToken id = msg.tokenid;
        uint256 value = msg.tokenvalue;

        require(id == trc10id, 'Not valid token');

        _trc10balance[msg.sender] = _trc10balance[msg.sender].add(value);

        return true;
    }

    function swap() public returns(bool) {
        uint _balanceBefore = _trc10balance[msg.sender];
        uint _balanceAfter = _withRate(_balanceBefore);
        _trc10balance[msg.sender] = _trc10balance[msg.sender].sub(_balanceBefore);
        _trc20balance[msg.sender] = _trc20balance[msg.sender].add(_balanceAfter);
        totalSwapTrc20.add(_balanceAfter);
        trc20.approve(msg.sender, _balanceAfter);

        return true;
    }

    function withdrawTrc20() public returns(bool) {
        uint _amount = trc20.allowance(address(this), msg.sender);
        require(uint(trc20.allowance(address(this), msg.sender)) >= _amount, "Balance not approved.");

        return trc20.transferFrom(address(this), msg.sender, _amount);
    }

    function _withRate(uint amount) private view returns(uint) {
        return amount.mul(100).div(rate);
    }
}
