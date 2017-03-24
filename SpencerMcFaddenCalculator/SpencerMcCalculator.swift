//
//  SpencerMcCalculator.swift
//  SpencerMcFaddenCalculator
//
//  Created by Spencer McFadden-Castro on 1/13/16.
//  Copyright © 2016 Spencer McFadden-Castro. All rights reserved.
//

import Foundation

class SpencerMcCalculator {
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get{
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var operationStack = [Op]()
    
    private var variableStack = [String:Op]()
    
    private var knownOperations = [String:Op]()
    
    init() {
        knownOperations["+/-"] = Op.UnaryOperation("+/-") { -$0 }
        knownOperations["×"] = Op.BinaryOperation("×", *)
        knownOperations["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOperations["+"] = Op.BinaryOperation("+", +)
        knownOperations["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOperations["√"] = Op.UnaryOperation("√", sqrt)
        knownOperations["Sine"] = Op.UnaryOperation("Sine", sin)
        knownOperations["Cos"] = Op.UnaryOperation("Cos", cos)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(operationStack)
        print("\(operationStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        operationStack.append(Op.Operand(operand))
        return evaluate()
    }
    
//    func variableValues(variable: String) -> Double? {
//
//    }
    
    func clear() -> Double {
        operationStack = [Op]()
        return 0
    }
    
//    func deleteOne() -> Double {
//        operationStack.
//        return 0
//    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOperations[symbol] {
            operationStack.append(operation)
        }
        return evaluate()
    }
    
}