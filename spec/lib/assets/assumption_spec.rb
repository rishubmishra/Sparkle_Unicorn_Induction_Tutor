#require 'spec_helper'
require 'json'
require_relative '../../../lib/assets/Assumption.rb'

RSpec.describe Assumption do
   
    
    context "Assumption.initalize" do
        

        it "handles empty JSON" do
           json_ex = { :assumptions => nil}.to_json
           expect{Assumption.new(json_ex)}.to raise_error(RuntimeError, "No Assumption(s) provided")
        end
        
        it "handles incorrect variable names" do
            json_ex = { :assumptions => {:bbb => ["4"]}}.to_json
            expect{Assumption.new(json_ex)}.to raise_error(RuntimeError, "Invalid Assumption variable(s)")
        end
        
        it "accepts correct input on 1 variable" do
            json_ex = {:assumptions => {:b => ["2"]}}.to_json
           
            expect{Assumption.new(json_ex)}.to_not raise_error
        end
        
        it "accepts correct input on multiple variables" do
            json_ex = {:assumptions => {:b => ["2"], :c =>["5"]}}.to_json
            expect{Assumption.new(json_ex)}.to_not raise_error
        end
        
        
    end
    
    context "Base.evaluate" do
       
        it "returns correctly for all variables" do
            json_ex = {:assumptions => {:b => ["2"], :c => ["5"]}}.to_json
            a = Assumption.new(json_ex)
            a.evaluate.should eq({"b" => ["2"], "c" => ["5"]})
        end
  
    end
    
    
    
    
    
end