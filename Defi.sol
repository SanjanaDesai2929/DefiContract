/**
 *Submitted for verification at BscScan.com on 2022-12-29
*/

// SPDX-License-Identifier: MIT LICENSE
pragma solidity ^0.8.2;

interface BEP20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function decimals() external view returns (uint8);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this;
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract OxyO2privateSale is Ownable {
    uint  oneday = 86400;
    uint256 public amount = 300000e18;
    uint constant SECONDS_PER_HOUR = 60 * 60;
    uint256 public MAX = 470000000e18;
    uint256 public lasttimestamp;
    address public DestAddress;
 uint256 public dayCount=1;

    BEP20 public ox2;
    constructor(address _token,address _DestAddress) {
        lasttimestamp = gettime(block.timestamp);
            ox2 = BEP20(_token);
            DestAddress=_DestAddress;
    }

    function Defi() public onlyOwner {
       uint256 second = block.timestamp - lasttimestamp;
       uint256 day = second / oneday;

       require(day > 0, "Timestamp exceeds");

       uint256 ox2balance = ox2.balanceOf(address(this));
      require(ox2balance > 0, "Balance exceeds");
        if (dayCount % 90 == 0) {
            amount += 30000e18;
            dayCount=0; // Increase amount by 30000
        }
   
       uint256 transferAmount = (ox2balance < amount * day) ? ox2balance : amount * day;
        ox2.transfer(DestAddress, transferAmount);

        lasttimestamp = gettime(block.timestamp);
          // Increase dayCount every 90 days
      

        dayCount++;
    }
  

    function remainingdays() public view returns (uint256) {
        uint256 second = block.timestamp - lasttimestamp;
        uint256 day = second / oneday;
        return day;
    }
    function gettime(uint time) private pure returns(uint){
       uint hour = ((time / 60 / 60) % 24);
        uint minute = (time / 60) % 60;
        uint sec = time % 60;
        uint minutensec = (minute*60) + sec;
        uint diffhour = (hour) * SECONDS_PER_HOUR;
        uint difftime = diffhour + minutensec;
        uint finaltime = time - difftime;
        return finaltime;
    }
function updateDestToken(address _token) public onlyOwner {
      require(_token != address(0), "Invalid token address");
    DestAddress = _token;
    }
}