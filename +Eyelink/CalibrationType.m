classdef CalibrationType
    properties (SetAccess = immutable)
        name
    end
    methods (Access = private)
        function this=CalibrationType(name)
            this.name=name;
        end
    end
    enumeration
        H3 ('H3')
        HV3 ('HV3')
        HV9 ('HV9')
        HV5 ('HV5')
        HV13 ('HV13')
    end
end