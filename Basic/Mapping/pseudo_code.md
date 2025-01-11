START

DEFINE a contract named Mapping

DECLARE state variables (stored on the blockchain): a. myMap - a public mapping from address to unsigned integer (uint256)

DEFINE a function get a. MARK function as public and view b. INPUT parameter _addr (Type: address) c. RETURN the value associated with _addr in myMap i. NOTE: If no value is set, the default value 0 is returned.

DEFINE a function set a. MARK function as public b. INPUT parameters: i. _addr (Type: address) ii. _i (Type: uint256) c. ASSIGN _i to myMap[_addr]

DEFINE a function remove a. MARK function as public b. INPUT parameter _addr (Type: address) c. DELETE the value associated with _addr in myMap i. NOTE: This resets the value to the default (0 for uint256).

END contract Mapping

DEFINE a contract named NestedMapping

DECLARE state variables (stored on the blockchain): a. nested - a public nested mapping from: i. Address to another mapping ii. The inner mapping: uint256 key to bool value

DEFINE a function get a. MARK function as public and view b. INPUT parameters: i. _addr1 (Type: address) ii. _i (Type: uint256) c. RETURN the boolean value associated with _addr1 and _i in nested i. NOTE: If no value is set, the default value false is returned.

DEFINE a function set a. MARK function as public b. INPUT parameters: i. _addr1 (Type: address) ii. _i (Type: uint256) iii. _boo (Type: bool) c. ASSIGN _boo to nested[_addr1][_i]

DEFINE a function remove a. MARK function as public b. INPUT parameters: i. _addr1 (Type: address) ii. _i (Type: uint256) c. DELETE the value associated with _addr1 and _i in nested i. NOTE: This resets the value to the default (false for bool).

END contract NestedMapping

END