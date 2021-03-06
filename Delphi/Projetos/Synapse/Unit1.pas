unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, HTTPSend, ExtCtrls, StdCtrls, jpeg;

type
  TForm1 = class(TForm)
    BotaoBaixarTexto: TButton;
    BotaoBaixarImagem: TButton;
    BotaoBaixarArquivo: TButton;
    Memo1: TMemo;
    Image1: TImage;
    procedure BotaoBaixarTextoClick(Sender: TObject);
    procedure BotaoBaixarImagemClick(Sender: TObject);
    procedure BotaoBaixarArquivoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function BaixarTexto(const URL: String): String;
var
  Strings: TStringList;
begin
  Strings := TStringList.Create;
  try
    if HttpGetText(URL, Strings) then
      Result := Strings.Text
    else
      Result := '';
  finally
    Strings.Free;
  end;
end;

function BaixarImagem(const URL: String; Graphic: TPicture): Boolean;
var
  Stream: TMemoryStream;
  Image: TJPEGImage;
begin
  Stream := TMemoryStream.Create;
  try
    if HttpGetBinary(URL, Stream) then
    begin
      Image := TJPEGImage.Create;
      try
        Stream.Seek(0, soFromBeginning);
        Image.LoadFromStream(Stream);
        Graphic.Assign(Image);
      finally
        Image.Free;
      end;
    end;
  finally
    Stream.Free;
  end;
end;

function BaixarArquivo(const URL: String; const FileName: String): Boolean;
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    Result := HttpGetBinary(URL, Stream);
  finally
    Stream.Free;
  end;
end;

procedure TForm1.BotaoBaixarTextoClick(Sender: TObject);
begin
	Memo1.Lines.Add(BaixarTexto('http://www.t2ti.com'));
end;

procedure TForm1.BotaoBaixarImagemClick(Sender: TObject);
begin
	BaixarImagem('http://www.t2ti.com/images/capas/cda_plus_ecftef.jpg', Image1.Picture);
end;

procedure TForm1.BotaoBaixarArquivoClick(Sender: TObject);
begin
   BaixarArquivo('http://www.t2ti.com/images/capas/cda_plus_ecftef.jpg', 'teste.jpg');
end;

end.
