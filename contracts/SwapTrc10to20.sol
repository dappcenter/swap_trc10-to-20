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
    bool public ratePositive = false;
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

    function setExchangeRate(uint value, bool positive) public onlyOwner returns (bool) {
        rate = value;
        ratePositive = positive;

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
        //trc20.approve(msg.sender, _balanceAfter);

        return true;
    }


    function withdrawTrc20() public returns(bool) {
        uint _amount = _trc20balance[msg.sender];
        _trc20balance[msg.sender] = 0;
        
        require(_amount > 0, "Zero balance");

        return trc20.transfer(msg.sender, _amount);
    }
    
    /*
     * @dev Withdraw basic ERC10 token to owner
     */ 
    function WDRL_Erc10ToOwner() public onlyOwner {
        return address(uint160(owner())).transferToken(getTRC10ContractBalance(), trc10id);
    }
    
    /*
     * @dev Withdraw any ERC10 token to owner
     */ 
    function WDRL_AnyErc10AnyToOwner(trcToken id) public onlyOwner {
        return address(uint160(owner())).transferToken(getTRC10ContractBalance(), id);
    }
        
    /*
     * @dev Withdraw any ERC20 token to owner, except basic ERC20 token
     */ 
    function WDRL_Erc20ToOwner(ITRC20 token) public onlyOwner returns (bool) {
        if (address(token) == address(trc20)) {
            revert('Owner cannot withdraw the basic erc20 contract.');
        }
        return token.transfer(address(uint160(owner())), getTRC20ContractBalance());
    }


    function _withRate(uint amount) private view returns(uint) {
        if (ratePositive) {
            return amount.mul(rate);
        }
        return amount.div(rate);
    }
}
