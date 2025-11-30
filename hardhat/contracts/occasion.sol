// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;


contract occasionContract {

    uint private nextId = 1;
    uint256 public ticketCount = 0;

    struct OccasionDetail {
            uint256 occasionId;
            address host;
            uint256 goal;
            uint256 deadline;

            uint256 amountRaised;
            bool isWithdrawn;
            mapping(address => uint256) totalOccasiontickets;
       }

       struct GeneralTicketDetail {
            uint256 ticketId;
            address attendee;
           //uint256 price;
            uint256 timestamp;

             
           bool held;
           mapping(address => uint256) totalGeneraltickets;
       }

    mapping(uint256 => OccasionDetail) public occasions;

    mapping(uint256 => GeneralTicketDetail) public defaultTicketDetails;



    //OccasionDetail[] occasionDetailsArray;
    //GeneralTicketDetail[] generalTicketDetailsArray;

    

    uint public maxTicketNo;
    uint256 public occasionCount = 0;

    uint256 public deadlineDay; //Occasion Day
    address payable public owner;

    event SuccessfulOcc(uint amount, uint when);
    event OccasionCreated(uint256 occasionId, address host, uint256 goal, uint256 deadline);
    event TicketBought(uint256 occasionId, address attendee, uint256 amount);

    modifier occasionExists(uint256 occasionId) {
           require(occasionId < occasionCount, "Occasion does not exist");
           _;
       }

    modifier beforeDeadline(uint256 occasionId) {
           require(block.timestamp <= occasions[occasionId].deadline, "occasion deadline has passed");
           _;
        }
    
    modifier afterDeadline(uint256 occasionId) {
           require(block.timestamp > occasions[occasionId].deadline, "occasion deadline has not passed yet");
           _;
       }

    constructor(uint _deadlineDay) payable {
        require(
            block.timestamp < _deadlineDay,
            "Unlock time should be in the future"
    );

    deadlineDay = _deadlineDay;
    owner = payable(msg.sender);
  }

  function withdraw(uint256 occasionId) external occasionExists(occasionId) afterDeadline(occasionId) {
        OccasionDetail storage occasion = occasions[occasionId];

        require(msg.sender == owner, "You aren't the owner");
        require(occasion.amountRaised >= occasion.goal, "Occasion goal not reached");
        require(!occasion.isWithdrawn, "Funds already withdrawn");
        occasion.isWithdrawn = true;

        emit SuccessfulOcc(address(this).balance, block.timestamp);

        owner.transfer(address(this).balance);
  }

    function createOccasion(uint256 goal, uint256 duration) external {
        require(goal > 0, "goal must be greater than zero");
        require(duration > 0, "Duration must be greater than zero");

        OccasionDetail storage newOccasion = occasions[occasionCount];
        newOccasion.host = msg.sender;
        newOccasion.goal = goal;
        newOccasion.deadline = block.timestamp + duration;
        

       
        emit OccasionCreated(occasionCount, msg.sender, goal, newOccasion.deadline);
        occasionCount++;
  }


  function buyticket(uint256 occasionId) external payable occasionExists(occasionId) beforeDeadline(occasionId) {

    require(msg.value>0, "amount must be greater than zero");

    require(block.timestamp <= deadlineDay, "You can't Buy a Ticket, The Event is not active");
    require(block.timestamp != deadlineDay, "You can't Buy a Ticket, The Event is not active");

    OccasionDetail storage occasion = occasions[occasionId];
    occasion.amountRaised += msg.value;
    occasion.totalOccasiontickets[msg.sender] += msg.value;

    emit TicketBought(occasionId, msg.sender, msg.value);


    owner.transfer(msg.value);
  }

}
