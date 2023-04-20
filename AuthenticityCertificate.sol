// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./TicketSafe.sol";

contract AuthenticityCertificateTickets is Ownable, Pausable {
    using SafeMath for uint256;
    using EnumerableSet for EnumerableSet.AddressSet;
    TicketSafe public ticketSafe;
    
struct Certificate {
bytes32 id;
address owner;
bytes32 typeId;
bytes32 itemId;
}

// Estructura para devolver el certificado emitido
struct Issue {
address certAddress;
bytes32 id;
address owner;
bytes32 typeId;
bytes32 itemId;
}

// Mapping of issued certificates, indexed by their address
mapping(address => Certificate) public certificates;

 constructor(address _ticketSafe) {
        ticketSafe = TicketSafe(_ticketSafe);
 }

// Método para emitir un nuevo certificado de autenticidad
function issue(address _owner, bytes32 _typeId, bytes32 _itemId) public whenNotPaused returns (bytes32) {
    // Generar un nuevo ID para el certificado
    bytes32 id = keccak256(abi.encodePacked(block.timestamp, _owner, _typeId, _itemId));
    // Emitir el certificado
    certificates[msg.sender] = Certificate(id, _owner, _typeId, _itemId);
    // Devolver el ID del certificado emitido
    return id;
}

// Method to verify if an authenticity certificate is valid
function isValid(address _certificate) public view returns (bool) {
    // Verify that the certificate exists
    if (certificates[_certificate].id == bytes32(0)) {
        return false;
    }
    // Return true if the certificate is valid
    return true;
}

// Pause and Unpause functions, only accessible by the contract owner
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
}
