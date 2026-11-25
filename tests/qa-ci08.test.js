const test = require("node:test");
const assert = require("node:assert/strict");

test("CI-08: fallo controlado para validar el pipeline", () => {
  assert.equal(1, 2);
});
