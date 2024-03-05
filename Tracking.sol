//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Tracking {
    enum ShipmentStatus { PENDING, IN_TRANSIT, DELIVERED }

    struct Shipment {
        address sender;
        address receiver;
        string destination;
        uint256 id;
        string prodName;
        uint256 price;
        string reqTemp;
        string quantity;
        ShipmentStatus status;
        bool isPaid;
    }
    mapping(address => Shipment[]) public shipments;
    uint256 public shipmentCount;

    struct TyepShipment {
        address sender;
        address receiver;
        string destination;
        uint256 id;
        string prodName;
        uint256 price;
        string reqTemp;
        string quantity;
        ShipmentStatus status;
        bool isPaid;
    }
    TyepShipment[] tyepShipments;

    event ShipmentCreated(address indexed sender, address indexed receiver, uint256 id, string prodName, uint256 price);
    event ShipmentIntransit(address indexed sender, address indexed receiver);
    event ShipmentDelivered(address indexed sender, address indexed receiver);
    event ShipmentPaid(address indexed sender, address indexed receiver, uint256 price);

    constructor() {
        shipmentCount = 0;
    }

    function createShipment(address _receiver, string memory _destination, uint _id,  
    string memory _prodName, uint256 _price, string memory _reqTemp, string memory _quantity) public payable {
        require(msg.value == _price, "Payment amount must match the price");

        Shipment memory shipment = Shipment(msg.sender, _receiver, _destination,
        _id, _prodName, _price, _reqTemp, _quantity, ShipmentStatus.PENDING, false);

        shipments[msg.sender].push(shipment);
        shipmentCount++;

        tyepShipments.push(
            TyepShipment (
                msg.sender,
                _receiver,
                _destination,
                _id,
                _prodName,
                _price,
                _reqTemp,
                _quantity,
                ShipmentStatus.PENDING,
                false
            )
        );
        emit ShipmentCreated(msg.sender, _receiver, _id, _prodName, _price);

    }

    function startShipment(address _sender, address _receiver, uint256 _index) public {
        Shipment storage shipment = shipments[_sender][_index];
        TyepShipment storage tyepShipments = tyepShipments[_index];

        require(shipment.receiver == _receiver, "Invalid receiver.");
        require(shipment.status == ShipmentStatus.PENDING, "Shipment already in transit.");

        shipment.status = ShipmentStatus.IN_TRANSIT;
        tyepShipments.status = ShipmentStatus.IN_TRANSIT;


        emit ShipmentIntransit(_sender, _receiver);
    }

    function completeShipment(address _sender, address _receiver, uint256 _index)
    public {
        Shipment storage shipments = shipments[_sender][_index];
        TyepShipment storage tyepShipments = tyepShipments[_index];

        require(shipments.receiver == _receiver, "Invalid receiver.");
        require(shipments.status == ShipmentStatus.IN_TRANSIT, "Shipment not in transit.");
        require(!shipments.isPaid, "Shipment already paid.");

        shipments.status = ShipmentStatus.DELIVERED;
        tyepShipments.status = ShipmentStatus.DELIVERED;
        
        uint256 amount = shipments.price;
        payable(shipments.sender).transfer(amount);
        shipments.isPaid = true;
        tyepShipments.isPaid = true;

        emit ShipmentDelivered(_sender, _receiver);
        emit ShipmentPaid(_sender, _receiver, amount);


    }

    function getShipment(address _sender, uint256 _index) public view returns (
        address, address, string memory, uint256, string memory, uint256, string memory, string memory, ShipmentStatus, bool) {
            Shipment memory shipment = shipments[_sender][_index];
            return (shipment.sender, shipment.receiver, shipment.destination, shipment.id, shipment.prodName, shipment.price, shipment.reqTemp, shipment.quantity, shipment.status, shipment.isPaid);
    }

    function getShipmentsCount(address _sender) public view returns (uint256) {
        return shipments[_sender].length;
    }

    function getAllTransactions()
    public
    view
    returns (TyepShipment[] memory) {
        return tyepShipments;
    }
    


    struct Product {
        uint256 id;
        string prodName;
        uint256 unitPrice;
        string prodType;
    }
}