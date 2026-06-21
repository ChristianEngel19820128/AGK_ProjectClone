
//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TGlobalTime
	
	RealNow as integer
	VirtualNow as integer
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

type TTime

	Stamp as integer
	Span as integer
	Multiplier as float
	Difference as integer
	Range as float
	CalcRange as float
	
endtype

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function TimeSet(Object ref as TTime,Span as integer,Range as float)

	// last timestamp
	Object.Stamp = 0
	// time span to check for
	Object.Span = Span
	// multiply range per millisecs
	Object.Multiplier = 1000/Span
	// calculated Time check value
	Object.Difference = 0
	// target time per span
	Object.Range = Range
	// claculated range for time
	Object.CalcRange = 0

endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function TimeGet(Object ref as TTime,Now as integer,Reset as integer)

	if Object.Difference = 0 or Reset = 1
		if Now > Object.Stamp + Object.Span
			Object.Difference = Now - Object.Stamp
			if Reset > 0 then Object.Stamp = Now
			TimebasedCalc(Object)
		endif
	endif
	
endfunction Object.Difference

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function TimeReset(Object ref as TTime,Now as integer)

	Object.Stamp = Now
	Object.Difference = 0

endfunction

//----------------------------------------------------------------------
// 
//----------------------------------------------------------------------

function TimebasedCalc(Object ref as TTime)
	
	// calculate the range for absolute time
	Object.CalcRange = Object.Difference*0.001*Object.Range*Object.Multiplier
	
endfunction Object.CalcRange

