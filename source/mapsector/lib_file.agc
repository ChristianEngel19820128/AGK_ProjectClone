
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

type TFilePath
	
	Path as string
	File as string
	
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

function FilePathSetAndCheck(Source ref as TFilePath)

	local Value as integer

	Value = 0
	
	if SetFolder(ReplaceString(Source.Path,"\","/",-1))
		if Len(Source.File) > 0
			if GetFileExists(Source.File)
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
	
		FileID = OpenToRead(Source.File)
						
		if FileID > 0
							
			while not FileEOF(FileID)						
				FileString = FileString + ReadLine(FileID)														
			endwhile
			
			CloseFile(FileID)
			
		endif
	
	endif

endfunction FileString

