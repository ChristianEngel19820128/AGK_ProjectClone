
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

type TFilePath
	
	Path as string
	Name as string
	
endtype

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function FilePathSet(Source as TFilePath)

	local Value as integer

	Value = FALSE
	
	if SetFolder(ReplaceString(Source.Path,"\","/",-1))
		Value = TRUE
	endif

endfunction Value

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function GetFilePathSetAndCheck(Source ref as TFilePath)
	
	local s as string
	
	s = ""
	
	if SetFolder(ReplaceString(Source.Path,"\","/",-1))
		if Len(Source.Name) > 0
			if GetFileExists(Source.Name)
				s = Source.Name
			endif
		endif
	endif

endfunction s

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function FilePathSetAndCheck(Source ref as TFilePath)

	local Value as integer

	Value = 0
	
	if SetFolder(ReplaceString(Source.Path,"\","/",-1))
		if Len(Source.Name) > 0
			if GetFileExists(Source.Name)
				Value = 1
			endif
		endif
	endif

endfunction Value

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

function ReadFileString(Source ref as TFilePath)

	local FileID as integer
	local FileString as string
	
	FileString = ""
	
	if FilePathSetAndCheck(Source) = 1
	
		FileID = OpenToRead(Source.Name)
						
		if FileID > 0
							
			while not FileEOF(FileID)						
				FileString = FileString + ReadLine(FileID)														
			endwhile
			
			CloseFile(FileID)
			
		endif
	
	endif

endfunction FileString

