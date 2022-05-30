// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import {AppStorage, Modifiers} from "../libraries/LibAppStorage.sol";
import {LibAccessRights} from "../libraries/LibAccessRights.sol";

contract AavegotchiAccessRightsFacet is Modifiers {
    event AccessRightSet(uint32 _tokenId, uint256 _action, uint256 _access);

    function setAccessRight(
        uint32 _tokenId,
        uint256 _action,
        uint256 _access
    ) public onlyAavegotchiOwner(_tokenId) onlyUnlocked(_tokenId) {
        require(LibAccessRights.verifyAccessRight(_action, _access), "Invalid access right");
        s.gotchiAccessRights[_tokenId][_action] = _access;
        emit AccessRightSet(_tokenId, _action, _access);
    }

    function setAccessRights(
        uint32[] memory _tokenIds,
        uint256[] memory _actions,
        uint256[] memory _accesses
    ) external {
        require(_tokenIds.length == _actions.length && _tokenIds.length == _accesses.length);
        for (uint256 i; i < _tokenIds.length; ) {
            setAccessRight(_tokenIds[i], _actions[i], _accesses[i]);
            unchecked {
                ++i;
            }
        }
    }

    function getAccessRight(uint32 _tokenId, uint256 _action) public view returns (uint256) {
        return s.gotchiAccessRights[_tokenId][_action];
    }

    function getAccessRights(uint32[] memory _tokenIds, uint256[] memory _actions) public view returns (uint256[] memory) {
        require(_tokenIds.length == _actions.length);
        uint256[] memory _accesses = new uint256[](_tokenIds.length);
        for (uint256 i; i < _tokenIds.length; ) {
            _accesses[i] = getAccessRight(_tokenIds[i], _actions[i]);
            unchecked {
                ++i;
            }
        }
        return _accesses;
    }
}
