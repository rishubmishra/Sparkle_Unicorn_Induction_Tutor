#require 'spec_helper'
require_relative '../../../lib/assets/Evaluate.rb'

RSpec.describe Evaluator do
    e = Evaluator.new
    
    context 'Evaluator.shunting_yard' do
        it 'successfully returns postfix array' do
            arg = ['2', '+', '2']
            postfix = e.shunting_yard(arg)
            expect(postfix).to eq ['2','2','+']
        end
        it 'handles order of operations' do 
            arg = ['2' , '+', '2', '*', '5']
            postfix = e.shunting_yard(arg)
            expect(postfix).to eq ['2', '2', '5', '*', '+']
            
            arg = ['4' , '^', '2', '+' ,'5' ,'/' ,'3' ,'-' ,'2' ,'*' ,'4']
            postfix = e.shunting_yard(arg)
            expect(postfix).to eq ['4', '2', '^', '5', '3', '/', '+', '2', '4', '*', '-']
        end
        it 'handles parentheses' do
            arg  = ['(', '2', '+', '1', ')', '*', '(', '3', '-', '4', ')']
            postfix = e.shunting_yard(arg)
            expect(postfix).to eq ['2', '1', '+', '3', '4', '-', '*']
            
            arg = ['(', '(', '4', '-', '6', ')', '^', '(', '8', '*', '2', '-', '(', '1', '+', '8', ')', '/', '3', '-', '4', '*', '(', '8', '+', '1', ')', '/', '(', '8', '*', '(', '8', '*', '(', '1', '+', '1', ')', ')', ')', ')', ')']
            postfix = e.shunting_yard(arg)
            expect(postfix).to eq ['4', '6', '-', '8', '2', '*', '1', '8', '+', '3', '/', '-', '4', '8', '1', '+', '*', '8', '8', '1', '1', '+', '*', '*', '/', '-', '^']
        end
        it 'handles varibles' do
            arg = ['n', '+', 'n']
            postfix = e.shunting_yard(arg)
            expect(postfix).to eq ['n', 'n', '+']
        end
        it 'throws on mismatched parentheses' do
            arg = ['(', '2', '+', '2']
            expect{e.shunting_yard(arg)}.to raise_error(RuntimeError, 'Mismatched Parentheses')
            
            arg = ['2', '+', '2', ')']
            expect{e.shunting_yard(arg)}.to raise_error(RuntimeError, 'Mismatched Parentheses')
       end
    end
    context 'postfix solver' do
        it 'correctly solves equations' do
            expect(e.solve(['4', '2', '+'])).to eq 6
            expect(e.solve(['4', '2', '-'])).to eq 2
            expect(e.solve(['4', '2', '*'])).to eq 8
            expect(e.solve(['4', '2', '/'])).to eq 2
            
            arg = ['4', '2', '^', '5', '3', '/', '+', '2', '4', '*', '-']
            val = (29.0/3.0 - e.solve(arg)).abs
            expect(val).to be < 0.0000000000001 
            
            arg = ['2', '1', '+', '3', '4', '-', '*']
            expect(e.solve(arg)).to eq -3
        end
        
        it 'fails on wrong number of operator inputs' do
            expect{e.solve(['2', '+'])}.to raise_error
        end
        
        it 'fails on varibles' do 
            expect{e.solve(['n', '+', 'n'])}.to raise_error
        end
            
    end
end