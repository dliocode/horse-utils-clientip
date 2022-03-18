unit Horse.Utils.ClientIP;

interface

uses
  Horse,
  {$IFDEF FPC }
  SysUtils;
  {$ELSE}
  System.SysUtils;
  {$ENDIF}

function ClientIP(const Req: THorseRequest): string;

implementation

function ClientIP(const Req: THorseRequest): string;
var
  LIP: string;
begin
  Result := EmptyStr;

  if not Trim(Req.Headers['HTTP_CLIENT_IP']).IsEmpty then
    Exit(Trim(Req.Headers['HTTP_CLIENT_IP']));

  for LIP in Trim(Req.Headers['HTTP_X_FORWARDED_FOR']).Split([',']) do
    if not Trim(LIP).IsEmpty then
      Exit(Trim(LIP));

  for LIP in Trim(Req.Headers['x-forwarded-for']).Split([',']) do
    if not Trim(LIP).IsEmpty then
      Exit(Trim(LIP));

  if not Trim(Req.Headers['HTTP_X_FORWARDED']).IsEmpty then
    Exit(Trim(Req.Headers['HTTP_X_FORWARDED']));

  if not Trim(Req.Headers['HTTP_X_CLUSTER_CLIENT_IP']).IsEmpty then
    Exit(Trim(Req.Headers['HTTP_X_CLUSTER_CLIENT_IP']));

  if not Trim(Req.Headers['HTTP_FORWARDED_FOR']).IsEmpty then
    Exit(Trim(Req.Headers['HTTP_FORWARDED_FOR']));

  if not Trim(Req.Headers['HTTP_FORWARDED']).IsEmpty then
    Exit(Trim(Req.Headers['HTTP_FORWARDED']));

  if not Trim(Req.Headers['REMOTE_ADDR']).IsEmpty then
    Exit(Trim(Req.Headers['REMOTE_ADDR']));

  {$IF DEFINED(FPC)}
  if not Trim(Req.RawWebRequest.RemoteAddress ).IsEmpty then
    Exit(Trim(Req.RawWebRequest.RemoteAddress));
  {$ELSE}
  if not Trim(Req.RawWebRequest.RemoteIP).IsEmpty then
    Exit(Trim(Req.RawWebRequest.RemoteIP));
  {$ENDIF}

  if not Trim(Req.RawWebRequest.RemoteAddr).IsEmpty then
    Exit(Trim(Req.RawWebRequest.RemoteAddr));

  if not Trim(Req.RawWebRequest.RemoteHost).IsEmpty then
    Exit(Trim(Req.RawWebRequest.RemoteHost));
end;

end.
