{% macro rating_bracket(rating_col) %}
    case
        when {{ rating_col }} is null then 'inconnu'  
        when {{ rating_col }} < 4.5 then 'moins de 4.5'
        when {{ rating_col }} <= 4.8 then '4.5 a 4.8'
        else 'plus de 4.8'
    end
{% endmacro %}
