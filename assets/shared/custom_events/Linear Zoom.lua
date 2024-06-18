function onEvent(name,value1,value2)
	if name == 'Linear Zoom' then
		doTweenZoom('camera', 'camGame', tonumber(value1), tonumber(value2), 'smootherStepIn');
		--debugPrint('Event triggered: ', name, duration, targetAlpha);
	end
end
