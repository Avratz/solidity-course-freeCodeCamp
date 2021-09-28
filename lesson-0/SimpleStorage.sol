// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 < 0.9.0;

contract SimpleStorage {
    //variable declaration
    //type visibility name
    uint256 public favoriteNumber;
    
    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }
    
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }
    
    struct People {
        uint256 favoriteNumber;
        string name;
    }
    
    People[] public people;
    mapping(string => uint256) public nameToFavoriteNumber;
    
    People public person = People({favoriteNumber:3, name: "juanito"});
    
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
    
}