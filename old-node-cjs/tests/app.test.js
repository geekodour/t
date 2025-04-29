import { sum } from '../src/app';
import { assert, expect, test } from 'vitest';

test('adds 1 + 2 to equal 3', () => {
  expect(sum(1, 2)).toBe(3);
});
