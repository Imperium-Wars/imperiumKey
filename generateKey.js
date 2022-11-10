const ec = require("starknet");

function generate_key_pair() {
  const starkKeyPair = ec.genKeyPair();
  console.log("starkKeyPair", starkKeyPair);
}

generate_key_pair();
