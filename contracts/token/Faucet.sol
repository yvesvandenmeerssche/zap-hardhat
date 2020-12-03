pragma solidity ^0.4.24;

contract Token {
    function transfer(address to, uint256 amount) public returns (bool);
    function balanceOf(address addr) public view returns (uint256);
}

contract Faucet {
    Token token;
    address public owner;
    uint256 public rate = 1000; // 1 ETH = 1000 ZAP
    event BUYZAP(address indexed _buyer, uint256 indexed _amount, uint indexed _rate);

    // 1: 1000 ratio

    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }

    constructor(address _token) public {
        owner = msg.sender;
        token = Token(_token);
    }

    event Log(uint256 n1, uint256 n2);

    function buyZap() public payable {
        require(msg.value > 0);
        uint256 amt = msg.value * rate;
        require(amt <= token.balanceOf(address(this)));
        token.transfer(msg.sender, amt);
        emit BUYZAP(msg.sender,amt,rate);
    }


    function withdrawTok() public ownerOnly {
        token.transfer(owner, token.balanceOf(address(this)));
    }

    function withdrawEther() public ownerOnly {
        owner.transfer(address(this).balance);
    }
}
