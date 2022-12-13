unit uPessoa;

interface

type
  TPessoa = class
  private

    Fnatureza: Integer;
    Fnmprimeiro: string;
    Fdtregistro: string;
    Fnmsegundo: string;
    Fdocumento: string;
    Fid: Integer;
    procedure Setdocumento(const Value: string);
    procedure Setdtregistro(const Value: string);
    procedure Setid(const Value: Integer);
    procedure Setnatureza(const Value: Integer);
    procedure Setnmprimeiro(const Value: string);
    procedure Setnmsegundo(const Value: string);

  public
    property id : Integer read Fid write Setid;
    property natureza : Integer read Fnatureza write Setnatureza;
    property documento : string read Fdocumento write Setdocumento;
    property nmprimeiro : string read Fnmprimeiro write Setnmprimeiro;
    property nmsegundo : string read Fnmsegundo write Setnmsegundo;
    property dtregistro : string read Fdtregistro write Setdtregistro;
  end;

implementation

{ TPessoa }

procedure TPessoa.Setdocumento(const Value: string);
begin
  Fdocumento := Value;
end;

procedure TPessoa.Setdtregistro(const Value: string);
begin
  Fdtregistro := Value;
end;

procedure TPessoa.Setid(const Value: Integer);
begin
  Fid := Value;
end;

procedure TPessoa.Setnatureza(const Value: Integer);
begin
  Fnatureza := Value;
end;

procedure TPessoa.Setnmprimeiro(const Value: string);
begin
  Fnmprimeiro := Value;
end;

procedure TPessoa.Setnmsegundo(const Value: string);
begin
  Fnmsegundo := Value;
end;

end.
