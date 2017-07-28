classdef (Abstract) Stimulus < Object.Object
    methods (Access = public, Abstract)
        present(this, adaptor);
    end
end