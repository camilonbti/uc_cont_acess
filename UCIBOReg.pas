unit UCIBOReg;

interface

uses Classes;

procedure Register;

implementation

uses UCIBOConn;

procedure Register;
begin
  RegisterComponents('UC Connectors', [TUCIBOConn]);
end;
end.
