classdef (Abstract) BitEnum < uint32
    methods (Access = public, Static)
        function enumBit=unions(varargin)
            enumBit=0;
            for i=1:numel(varargin)
                enumBit=bitor(enumBit,varargin{i});
            end
        end
    end

    methods (Access = public)
        function this=BitEnum(value)
            this@uint32(value);
        end

        function enumBit=union(this, enum)
            enumBit=bitor(this,enum);
        end

        function res=isIn(this, enumBit)
            res=bitand(enumBit,this)~=0;
        end
    end
end
