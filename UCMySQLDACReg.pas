unit UCMySQLDACReg;

interface

uses Classes;

procedure Register;

implementation

uses UCMySQLDACConn;

procedure Register;
begin
  RegisterComponents('UC Connectors', [TUCMySQLDACConn]);
end;
end.
