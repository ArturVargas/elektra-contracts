// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title 
 elektra_SmartContract
 */
import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPriceOracle} from "@aave/core-v3/contracts/interfaces/IPriceOracle.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

contract Elektra {

    address constant aavePoolProxy = 0x6Ae43d3271ff6888e7Fc43Fd7321a503ff738951;
    address constant collateralToken = 0xC558DBdd856501FCd9aaF1E62eae57A9F0629a3c; //eth ftm
    address constant debtToken = 0x42A218F7bd03c63c4835496506492A383EfcF726; //usdc ftm

    mapping(address => uint256) collateralValue;
    mapping(address => uint256) totalDebt;


    event CollateralDeposit(
        address indexed sender, 
        uint256 amount, 
        uint256 totalOfCollateralDeposited
    );
    event Debt(
        address indexed sender, 
        uint256 amount, 
        uint256 totalDebt
    );
    event Withdrawal(
        address indexed sender, 
        uint256 amount, 
        uint256 totalOfCollateralDeposited
    );

    function depositCollateral(uint256 _amount)
        external
    {

        if (_amount == 0) {
            revert();
        }
        IERC20(collateralToken).transferFrom(msg.sender, address(this), _amount);

        IERC20(collateralToken).approve(address(aavePoolProxy), _amount);

        IPool(aavePoolProxy).supply(collateralToken, _amount, address(this), 0);
        collateralValue[msg.sender] += _amount;
        emit CollateralDeposit(msg.sender, _amount, collateralValue[msg.sender]);
    }
    
    function withdrawCollateral(uint256 _amount) public {
        if (_amount == 0 || collateralValue[msg.sender] < _amount) {
            revert();
        }
        if (totalDebt[msg.sender] > 0) {
            revert();
        }
        IPool(aavePoolProxy).withdraw(collateralToken, _amount, address(this));
        collateralValue[msg.sender] -= _amount;
        IERC20(collateralToken).transferFrom(address(this), msg.sender, _amount);

        emit Withdrawal(msg.sender, _amount, collateralValue[msg.sender]);
    }

    function takeLoan(uint256 _amount) public {
        if (_amount == 0 || collateralValue[msg.sender] < _amount) {
            revert();
        }
       
        IPool(aavePoolProxy).borrow(debtToken, _amount, 1, 0, address(this));
        totalDebt[msg.sender] += _amount;
        IERC20(debtToken).transferFrom(address(this), msg.sender, _amount);
        emit Debt(msg.sender, _amount, totalDebt[msg.sender]);
    }

    function repay(uint256 _amount) public {
        if (_amount <= 0) {
            revert();
        }
        IERC20(debtToken).transferFrom(msg.sender, address(this), _amount);
        IPool(aavePoolProxy).repay(debtToken, _amount, 2, address(this));
    }

    function seeCollateralValue(address _sender) public view returns (uint256) {
        return collateralValue[_sender];
    }

    function seeTotalDebtGet(address _sender) public view returns (uint256) {
        return totalDebt[_sender];
    }

}