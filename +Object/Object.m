classdef Object < handle
    properties(Access = private)
        id
    end
    
    methods (Access = private, Static)
        function id=nextId()
            persistent maxid;
            if isempty(maxid)
                maxid=0;
                Object.Object.Null();
            end
            id=maxid;
            maxid=maxid+1;
        end
    end
    
    methods (Access = public, Static)
        function null=Null()
            persistent nullObj
            if isempty(nullObj)
                nullObj=Object.Object();
            end
            null=nullObj;
        end
    end
    
    methods (Access = public)
        function this = Object()
            this.id=Object.Object.nextId();
        end
        
        function id=getId(this)
            id=this.id;
        end
    end
end