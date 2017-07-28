classdef Storage < Object.Object
    properties (Access = private)
        saveInputSignalPredicate
        saveOutputSignalPredicate
        saveVariablePredicate
        saveDataHandler
        saveStateHandler
        
        inputSignalLastValue
        outputSignalLastValue
        variableLastValue
    end
    
    methods (Access = public)
        function this=Storage(saveDataHandler, saveStateHandler)
            truePred=@(name)true;
            this.saveInputSignalPredicate=truePred;
            this.saveOutputSignalPredicate=truePred;
            this.saveVariablePredicate=truePred;
            this.saveDataHandler=saveDataHandler;
            this.saveStateHandler=saveStateHandler;
        end
        
        function setInputSignalPredicate(this,saveInputSignalPredicate)
            this.saveInputSignalPredicate=saveInputSignalPredicate;
        end
        
        function setOutputSignalPredicate(this,saveOutputSignalPredicate)
            this.saveOutputSignalPredicate=saveOutputSignalPredicate;
        end
        
        function setVariablePredicate(this,saveVariablePredicate)
            this.saveVariablePredicate=saveVariablePredicate;
        end
        
        function saveInputSignal(this, name, value)
            if this.saveInputSignalPredicate(name)
                this.saveDataHandler(name, value);
            end
        end
        
        function saveOutputSignal(this, name, value)
            if this.saveOutputSignalPredicate(name)
                this.saveDataHandler(name, value);
            end
        end
        
        function saveVariable(this, name, value)
            if this.saveVariablePredicate(name)
                this.saveDataHandler(name, value);
            end
        end
        
        function saveStateTransition(this, sourceName, destinationName)
            this.saveStateHandler(sourceName, destinationName);
        end
                
    end
    
end