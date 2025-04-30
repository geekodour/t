import { describe, it, expect } from "vitest";
import { sum } from "../src/app.ts";

describe("Calculator", () => {
  it("should add two numbers correctly", () => {
    const num1: number = 5; // Can use types in tests
    const num2: number = 10;
    const expectedResult: number = 15;

    const result = sum(num1, num2);

    expect(result).toBe(expectedResult);
  });

  it("should handle negative numbers", () => {
    expect(sum(-5, -10)).toBe(-15);
  });

  it("should handle adding zero", () => {
    expect(sum(5, 0)).toBe(5);
    expect(sum(0, 5)).toBe(5);
  });
});
