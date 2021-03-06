pragma solidity >=0.5.0;

import "./zombiehelper.sol";

contract ZombieAttack is ZombieHelper {
    uint256 randNonce = 0;
    uint256 attackVictoryProbability = 70;

    function randMod(uint256 _modulus) internal returns (uint256) {
        randNonce = randNonce.add(1);
        return
            uint256(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % //takes values and packs them and uses keccak to convert to a random hash.
            _modulus; // hash is converted to an uint and via modulus, will generate a random number between 1&100.
        //
    } // this isnt really a secure way to generat random numbers, but it doesnt matter too much for this game.

   function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      myZombie.winCount = myZombie.winCount.add(1);
      myZombie.level = myZombie.level.add(1);
      enemyZombie.lossCount = enemyZombie.lossCount.add(1);
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie") //from zombiefeeding.sol, we need zombieId, targetDna, and a string.
    } else {
      myZombie.lossCount = myZombie.lossCount.add(1);
      enemyZombie.winCount =  enemyZombie.winCount.add(1);
      _triggerCooldown(myZombie);

    }
}
