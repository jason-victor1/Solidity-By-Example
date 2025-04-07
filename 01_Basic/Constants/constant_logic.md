// 🧠 constant vs immutable - Car Analogy

// constant = factory-welded part
// - Value must be known at compile time.
// - Hardcoded into bytecode = very gas efficient.
// - Example: Number of wheels on a car.

uint256 public constant WHEELS = 4;

// immutable = pre-delivery custom part
// - Value set once during construction (constructor).
// - Cannot change afterward.
// - Example: Custom paint color chosen by buyer.

address public immutable carOwner;

constructor() {
carOwner = msg.sender; // set once at deployment
}
