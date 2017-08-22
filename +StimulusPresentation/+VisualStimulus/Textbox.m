classdef Textbox < StimulusPresentation.Stimulus
    properties (Access = private)
        text
        position
        color
    end
    
    methods (Access = public)
        function this=Textbox(text, position, color)
            this@StimulusPresentation.Stimulus('Textbox');
            this.text=text;
            this.position=position;
            this.color=color;
        end
        
        function text=getText(this)
            text=this.text;
        end
        
        function position=getPosition(this)
            position=this.position;
        end
        
        function color=getColor(this)
            color=this.color;
        end
    end
end