// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./AuthenticityCertificateTickets.sol";

interface IPOAP {
    function mint(address to, uint256 eventId) external;
}

contract TicketSafe is ERC721, Ownable, Pausable {
    using Counters for Counters.Counter;
    Counters.Counter private _ticketIds;
    Counters.Counter private _experienceId;

    IERC20 public etherToken;
    IERC20 public usdtToken;

    uint256 private commission = 5; // Comisión del 5%

    address public eventCreator;

    IPOAP public poapContract;

    AuthenticityCertificateTickets public authenticityCertificateContract;

    struct Experience {
        uint256 id;
        bool isEvent;
        bool isService;
        bool isExperiencePOAP;
        string name;
        string category;
        string description;
        string location;
        uint256 date;
        uint256[] dates;
        uint256[] availableHours;
        uint256 merchandiseQuantity;
        string ipfsPhotoHash;
        string ipfsVideoHash;
        uint256 cancellationPeriod;
        uint256 expirationTime;
        bool resellable;
        uint minPrice;
        uint maxPrice;
        bool refunded;
        string streamingPlatform;
        uint256 ticketPrice;
        uint256 maxTickets;
        uint256 rating;
        string review;
        string virtualLocation;
        string currency;
        address authenticityCertificateTickets;
        bytes32 qrCode;
        Seat[] seats;
        SeatType[] seatTypes;
        uint256 totalTicketsSold;
    }

struct Seat {
    uint row; // Fila del asiento
    uint column; // Columna del asiento
    bool occupied; // Indica si el asiento está ocupado
    uint ticketId; // ID del ticket asociado al asiento
    address owner; // Propietario del asiento
}

    struct SeatType {
        string seat_type; // Nombre del tipo de asiento (General, VIP, etc.)
        uint id; // ID del asiento
        bool available; // Indica si el asiento está disponible para la compra
        address owner; // Propietario del asiento
    }

    struct ExperienceRevenue {
        uint256 etherRevenue;
        uint256 usdtRevenue;
    }

    mapping(uint256 => Experience) public experiences;
    mapping(uint256 => uint256) public ticketToExperience;
    mapping(uint256 => Seat) public seats;
    mapping(uint256 => SeatType) public seatTypes;
    mapping(uint256 => ExperienceRevenue) public experienceRevenue;
    mapping(address => bool) public attended;
    mapping(uint256 => bytes32) public certificates;
    
    event ExperienceCreated(uint256 experienceId, address creator);
    event TicketPurchased(address buyer, uint256 experienceId, uint256 ticketId, uint256 price);
    event Withdraw(address indexed account, uint256 amount);

    constructor(address _etherAddress, address _usdtAddress, address _poapAddress, address _authenticityCertificateAddress) ERC721("TicketSafe", "TS") {
        etherToken = IERC20(_etherAddress);
        usdtToken = IERC20(_usdtAddress);
        poapContract = IPOAP(_poapAddress);
        eventCreator = msg.sender;
        authenticityCertificateContract = AuthenticityCertificateTickets(_authenticityCertificateAddress); 
    }

function createExperience(bool _isEvent, bool _isService, bool _isExperiencePOAP, string memory _name, uint256 _date, uint256 _ticketPrice, uint256 _maxTickets, uint256 _numRows, uint256 _numColumns) external whenNotPaused {
    _experienceId.increment();
    uint256 experienceId = _experienceId.current();

    Experience memory eventTicket = Experience({
        id: experienceId,
        isEvent: _isEvent,
        isService: _isService,
        isExperiencePOAP: _isExperiencePOAP,
        name: _name,
        category: "",
        description: "",
        location: "",
        date: _date,
        dates: new uint256[](0),
        availableHours: new uint256[](0),
        merchandiseQuantity: 0,
        ipfsPhotoHash: "",
        ipfsVideoHash: "",
        cancellationPeriod: 0,
        expirationTime: 0,
        resellable: false,
        minPrice: 0,
        maxPrice: 0,
        refunded: false,
        streamingPlatform: "",
        ticketPrice: _ticketPrice - (_ticketPrice * commission / 100),
        maxTickets: _maxTickets,
        rating: 0,
        review: "",
        virtualLocation: "",
        currency: "",
        authenticityCertificateTickets: address(0),
        qrCode: bytes32(0),
        seats: new Seat[](_numRows * _numColumns),
        seatTypes: new SeatType[](_numRows * _numColumns),
        totalTicketsSold: 0
    });

    if (_isEvent) {
        uint256 seatIndex = 0;
        for (uint256 i = 0; i < _numRows; i++) {
            for (uint256 j = 0; j < _numColumns; j++) {
                Seat memory seat = Seat({
                    row: i,
                    column: j,
                    occupied: false,
                    ticketId: seatIndex,
                    owner: address(0)
                });
                eventTicket.seats[seatIndex] = seat;

                SeatType memory seatType = SeatType({
                    seat_type: "General",
                    id: seatIndex,
                    available: true,
                    owner: address(0)
                });
                eventTicket.seatTypes[seatIndex] = seatType;

                seatIndex++;
            }
        }
    }

    experiences[experienceId] = eventTicket;

    emit ExperienceCreated(experienceId, msg.sender);
}

function createSeatType(uint256 experienceId, string memory seatType) external whenNotPaused {
    Experience storage requestedExperience = experiences[experienceId];
    uint id = requestedExperience.seatTypes.length;
    SeatType memory newSeatType = SeatType({
        seat_type: seatType,
        id: id,
        available: true,
        owner: address(0)
    });
    requestedExperience.seatTypes.push(newSeatType);
}

function filterExperiences(uint256 _id, bool _isEvent, bool _isService, bool _isExperiencePOAP, string memory _name, string memory _category, string memory _description, string memory _location, uint256 _date, uint256 _cancellationPeriod, uint256 _expirationTime, bool _resellable, uint _minPrice, uint _maxPrice, bool _refunded, string memory _streamingPlatform, uint256 _rating, string memory _review,  string memory _virtualLocation, string memory _currency, address _authenticityCertificateTickets, bytes32 _qrCode, uint256 _totalTicketsSold, uint _row, uint _column, string memory _seatType) public view returns (uint256[] memory) {
    uint256[] memory matchingExperienceIds = new uint256[](_experienceId.current());
    uint256 counter = 0;

    for (uint256 i = 1; i <= _experienceId.current(); i++) {
        Experience storage experience = experiences[i];
        bool isMatch = true;

        if (_id != 0 && experience.id != _id) {
            isMatch = false;
        }

        if (_isEvent != experience.isEvent) {
            isMatch = false;
        }

        if (_isService != experience.isService) {
            isMatch = false;
        }

        if (_isExperiencePOAP != experience.isExperiencePOAP) {
            isMatch = false;
        }

        if (bytes(_name).length > 0 && !stringsEqual(experience.name, _name)) {
            isMatch = false;
        }

        if (bytes(_category).length > 0 && !stringsEqual(experience.category, _category)) {
            isMatch = false;
        }

        if (bytes(_description).length > 0 && !stringsEqual(experience.description, _description)) {
            isMatch = false;
        }

           if (bytes(_location).length > 0 && !stringsEqual(experience.location, _location)) {
            isMatch = false;
        }

        if (_date != 0 && experience.date != _date) {
            isMatch = false;
        }

        if (_cancellationPeriod != 0 && experience.cancellationPeriod != _cancellationPeriod) {
            isMatch = false;
        }

         if (_expirationTime != 0 && experience.expirationTime != _expirationTime) {
            isMatch = false;
        }

         if (_resellable && !experience.resellable) {
            isMatch = false;
        }

        if (_minPrice != 0 && experience.minPrice < _minPrice) {
            isMatch = false;
        }

        if (_maxPrice != 0 && experience.maxPrice > _maxPrice) {
            isMatch = false;
        }

         if (_refunded && !experience.refunded) {
            isMatch = false;
        }

        if (bytes(_streamingPlatform).length > 0 && !stringsEqual(experience.streamingPlatform, _streamingPlatform)) {
            isMatch = false;
        }

         if (_rating != 0 && experience.rating != _rating) {
            isMatch = false;
        }

          if (bytes(_review).length > 0 && !stringsEqual(experience.review, _review)) {
            isMatch = false;
        }

         if (bytes(_virtualLocation).length > 0 && !stringsEqual(experience.virtualLocation, _virtualLocation)) {
        isMatch = false;
        }

        if (bytes(_currency).length > 0 && !stringsEqual(experience.currency, _currency)) {
        isMatch = false;
    }

     if (_authenticityCertificateTickets != address(0) && experience.authenticityCertificateTickets != _authenticityCertificateTickets) {
        isMatch = false;
    }

    if (_qrCode != bytes32(0) && experience.qrCode != _qrCode) {
        isMatch = false;
    }

    if (_totalTicketsSold != 0 && experience.totalTicketsSold != _totalTicketsSold) {
        isMatch = false;
    }

   if (_row != 0 || _column != 0) {
    Seat storage seat = seats[experience.id];
    if (_row != 0 && seat.row != _row) {
        isMatch = false;
    }

    if (_column != 0 && seat.column != _column) {
        isMatch = false;
    }
}

if (bytes(_seatType).length > 0) {
    SeatType storage seatTypeInstance = seatTypes[experience.id];
    if (!stringsEqual(seatTypeInstance.seat_type, _seatType)) {
        isMatch = false;
    }
}
          if (isMatch) {
            matchingExperienceIds[counter] = i;
            counter++;
        }
    }

    uint256[] memory result = new uint256[](counter);
    for (uint256 j = 0; j < counter; j++) {
        result[j] = matchingExperienceIds[j];
    }
    return result;
}

function stringsEqual(string memory _a, string memory _b) internal pure returns (bool) {
    return keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b));
}

function buyTicketERC20(uint256 experienceId, uint256 _ticketId, uint256 _seatTypeId, uint _row, uint _column, IERC20 token) external whenNotPaused {
    require(owner() == msg.sender, "Solo se permite el acceso desde el propietario del contrato.");
    require(_exists(_ticketId), "Ticket no existe.");
    require(ticketToExperience[_ticketId] == experienceId, "Ticket no pertenece a la experiencia");
    require(ownerOf(_ticketId) == address(this), "Ticket ya comprado.");
    Experience storage requestedExperience = experiences[experienceId];
    require(requestedExperience.date > block.timestamp, "Experiencia ya finalizada.");
    require(requestedExperience.totalTicketsSold < requestedExperience.maxTickets, "Experiencia agotada.");
    uint256 price = requestedExperience.ticketPrice;
    require(token.balanceOf(msg.sender) >= price, "Saldo insuficiente.");
    require(token.allowance(msg.sender, address(this)) >= price, "Limite de aprobacion insuficiente.");

    token.transferFrom(msg.sender, address(this), price);
    requestedExperience.totalTicketsSold++;

    // Emitir el certificado de autenticidad para el ticket
    bytes32 typeId = "Ticket";
    bytes32 itemId = bytes32(_ticketId);
    authenticityCertificateContract.issue(msg.sender, typeId, itemId);

    // Asignar el certificado al ID del ticket
    certificates[_ticketId] = itemId;

    _transfer(address(this), msg.sender, _ticketId);

    // Verificar disponibilidad del asiento seleccionado y asignarlo al comprador
    Seat storage selectedSeat = requestedExperience.seats[_row * requestedExperience.seatTypes.length + _column];
    require(!selectedSeat.occupied, "Asiento no disponible.");
    selectedSeat.occupied = true;
    selectedSeat.owner = msg.sender;

    // Asignar el tipo de asiento seleccionado al comprador
    SeatType storage selectedSeatType = requestedExperience.seatTypes[_seatTypeId];
    require(selectedSeatType.available, "Asiento no disponible.");
    selectedSeatType.available = false;
    selectedSeatType.owner = msg.sender;

    if (requestedExperience.isExperiencePOAP) {
        poapContract.mint(msg.sender, experienceId);

        // Actualizar los saldos de ether y usdt del evento
        if (address(token) == address(etherToken)) {
            experienceRevenue[experienceId].etherRevenue += price;
        } else if (address(token) == address(usdtToken)) {
            experienceRevenue[experienceId].usdtRevenue += price;
        }
    }
}

function confirmAttendance(uint256 experienceId) external whenNotPaused {
Experience storage requestedExperience = experiences[experienceId];
require(requestedExperience.date < block.timestamp, "Experiencia no finalizada.");
require(!attended[msg.sender], "Asistencia ya confirmada.");

attended[msg.sender] = true;

if (requestedExperience.isExperiencePOAP) {
poapContract.mint(msg.sender, experienceId);
}
}

function withdraw(uint256 experienceId) external whenNotPaused {
require(msg.sender == eventCreator, "Solo el creador del evento puede retirar los fondos");
ExperienceRevenue storage revenue = experienceRevenue[experienceId];
uint256 etherBalance = revenue.etherRevenue;
uint256 usdtBalance = revenue.usdtRevenue;
uint256 commissionAmountEther = 0;
uint256 commissionAmountUsdt = 0;

if (etherBalance > 0) {
commissionAmountEther = etherBalance * commission / 100;
etherToken.transfer(owner(), etherBalance - commissionAmountEther);
revenue.etherRevenue = commissionAmountEther;
}

if (usdtBalance > 0) {
commissionAmountUsdt = usdtBalance * commission / 100;
usdtToken.transfer(owner(), usdtBalance - commissionAmountUsdt);
revenue.usdtRevenue = commissionAmountUsdt;
}

emit Withdraw(owner(), etherBalance - commissionAmountEther);
}

// Pause and Unpause functions, only accessible by the contract owner
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
}
