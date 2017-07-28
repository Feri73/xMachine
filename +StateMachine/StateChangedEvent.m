classdef StateChangedEvent < event.EventData
    properties (Access = public)
        sourceName
        destinationName
    end
    
    methods (Access = public)
        function this=StateChangedEvent(sourceName,destinationName)
            this.sourceName=sourceName;
            this.destinationName=destinationName;
        end
    end
end