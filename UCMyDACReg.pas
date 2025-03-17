unit UCMyDACReg;

interface

uses Classes;

procedure Register;

implementation

uses UCMyDACConn;

procedure Register;
begin
  RegisterComponents('UC Connectors', [TUCMyDACConn]);
end;
end.
