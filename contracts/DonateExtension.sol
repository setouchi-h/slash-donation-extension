// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ISlashCustomPlugin.sol";
import "./libs/UniversalERC20.sol";

error DonateExtension__InvalidAmount();
error DonateExtension__TransferFailed();

contract DonateExtension is ISlashCustomPlugin, Ownable {
    using UniversalERC20 for IERC20;

    function receivePayment(
        address receiveToken,
        uint256 amount,
        bytes calldata,
        string calldata,
        bytes calldata reserved
    ) external payable override {
        if (amount <= 0) {
            revert DonateExtension__InvalidAmount();
        }

        address receipt = 0x274A766227e95ED5470b4d6E5dCC3a4E446fF213;
        uint256 donationAmount = amount * 10 / 100;
        uint256 receiveAmount = amount - donationAmount;

        IERC20(receiveToken).universalTransferFrom(msg.sender, receipt, donationAmount);
        IERC20(receiveToken).universalTransferFrom(msg.sender, owner(), receiveAmount);
    }

    function supportSlashExtensionInterface() external pure override returns (uint8) {
        return 2;
    }
}
