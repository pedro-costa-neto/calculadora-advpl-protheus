#include "totvs.ch"
#include "protheus.ch"

user function CalcOOP()
	Local oCalc		:= ClassCalc():New()
	Local oJanela	:= Tdialog():New()
	Local oGetVisor
	Local aBT := {} 
	Local oBSoma, oBSub, oBMult, oBDiv, oBIgual, oBPont, oBZero
	Local nH := 0, nFator := 0
	Local cBloco := "", bBloco
		
	oGetVisor:= TGet():Create(oJanela)
	oGetVisor:nLeft    	:= 10 
	oGetVisor:nTop     	:= 10
	oGetVisor:nWidth   	:= 300
	oGetVisor:nHeight  	:= 50
	oGetVisor:cVariable := "oCalc:visor"
	oGetVisor:bSetGet  := {|| If(PCount()>0,oCalc:visor:=u,oCalc:visor) }
	
	nH := (oGetVisor:nWidth/5)-7
	
	for nI:=1 to 20
	
		aAdd(aBT, TButton():Create(oJanela))
		aBT[nI]:nWidth 	:=  nH
		aBT[nI]:nHeight :=  nH
		
		nFator 			:= nI/5 //round((((nI-1)*9)%10)/4,0)-1
		nFator			:= if(nFator<1.1,1,nFator)
		nFator			:= if(nFator>1 .and. nFator<2.1,2,nFator)
		nFator			:= if(nFator>2 .and. nFator<3.1,3,nFator)
		nFator			:= if(nFator>3 .and. nFator<4.1,4,nFator)
		
		aBT[nI]:nTop 	:= oGetVisor:nHeight+20+(nH+10)*(nFator-1)
		
		nFator			:= nI%5 //((nI-1)%4)
		nFator			:= if(nFator=0,5,nFator)
		aBT[nI]:nLeft 	:= oGetVisor:nLeft+(nH+10)*(nFator-1)
		aBT[nI]:nClrText:=10
		//aBT[nI]:nClrPane:=nI*10000000
				
		aBT[nI]:cCaption:= oCalc:tit(nI)
		cBloco 			:= "{|| oCalc:dig("+str(nI,2,0)+")}"
		aBT[nI]:bAction	:= &(cBloco)
	
	next

	oJanela:nWidth		:= oGetVisor:nWidth+25
	oJanela:nHeight		:= nH*6+30
	oJanela:lescclose	:= .T.
	oJanela:center(.t.)
	oJanela:Activate()

Return

// Classe Calculadora
Class ClassCalc
   data visor  as string
   data vInter  as string
   data result as numeric
   
   method new() Constructor
   method dig(valor)
   method tit(valor)
   method show(valor)
EndClass

// Construtor
Method New() class ClassCalc
	Self:vInter := "0"
	Self:show()
Return self   // reotrna o objeto criado

Method show(valor,cPict) class ClassCalc
	default valor := "0"
	default cPict := "@E 999,999,999,999,999,999"
	Self:visor 	:= padl(allTrim(TRANSFORM(val(valor), cPict)),50)
Return


method tit(valor) class ClassCalc
	Local aTit :=  {'7','8','9','+','Limp',;
					'4','5','6','-','<-',;
					'1','2','3','*','%',;
					'.','0','=','/','Exp'}
Return aTit[valor]

Method dig(valor) class ClassCalc
	Local n 		:= 0 //len(allTrim(Self:visor))
	Local cTec 		:= self:tit(valor)
	Local cPict     := "@E 999,999,999,999,999,999"
	Local nPosPto   := 0
	Self:visor   := StrTran(allTrim(Self:visor), ".", "")
	Self:visor   := StrTran(allTrim(Self:visor), ",", ".")
	
	nPosPto := At('.',self:visor)
	
	//Self:visor   := allTrim(str(val(self:visor)))
	
	n := len(allTrim(Self:visor))
	
	
	do case
		case IsDigit(cTec)
			if n<16 
				if allTrim(self:visor) == '0'
					self:visor := cTec
				else
					self:visor := allTrim(self:visor)+cTec
				endIf
			endIf
		
		case cTec = '.'
			if n<16 .and. nPosPto=0
				self:visor := allTrim(self:visor)+cTec
			endIf
		
		case cTec = 'Limp'
			self:show()
			self:vInter := "0"
		
		case cTec = '<-'
			self:visor := subStr(self:visor,1,n-1)
		
		case cTec $ '+.-.*./'
			self:vInter += self:visor
			self:vInter := str(&(self:vInter))
			self:vInter += cTec
			self:show()
		
		case cTec = "%"
			cOper := Right(self:vInter,1)
			
			do case
				case cOper = "0"
					self:visor += "/100"
					self:visor := str(&(self:visor))
					
				case cTec $ '+.-.*./'
					self:vInter += self:visor
					self:vInter := str(&(self:vInter))
					self:vInter += cTec
					self:show()
			endCase
			
		case cTec = '='
			self:vInter += self:visor
			self:visor := str(&(self:vInter))
			self:vInter := "0"
	endcase 
	
	n := len(allTrim(Self:visor))
	nPosPto := At('.',allTrim(self:visor))
	
	if nPosPto>0
		cPict += "."+REPLICATE("9", n-nPosPto)
	endIf
	
	self:show(self:visor,cPict)
Return









