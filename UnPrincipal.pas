unit UnPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.ExtCtrls, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmPrincipal = class(TForm)
    Panel1: TPanel;
    edtQuantidade: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    edtDescricao: TEdit;
    dsDados: TDataSource;
    Button2: TButton;
    cdsDados: TFDMemTable;
    cdsDadosID: TIntegerField;
    cdsDadosDESCRICAO: TStringField;
    dsDados2: TDataSource;
    cdsDados2: TFDMemTable;
    cdsDados2ID: TIntegerField;
    cdsDados2DESCRICAO: TStringField;
    GroupBox1: TGroupBox;
    DBGrid1: TDBGrid;
    GroupBox2: TGroupBox;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    lblTask: TLabel;
    lblAnonima: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure InserirRegistros();
    procedure InserirRegistros2();
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  System.Threading;
{$R *.dfm}

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
  // Anonima
  lblAnonima.Caption := 'Thread em execu��o';

  TThread.CreateAnonymousThread(
    procedure
    begin
      InserirRegistros2();

      TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          cdsDados2.Active := False;
          cdsDados2.Active := True;
        end);
    end).Start;

end;

procedure TfrmPrincipal.Button2Click(Sender: TObject);
begin
  lblTask.Caption := 'Thread em execu��o';

  ttask.Run(
    procedure
    begin
      InserirRegistros();

      TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          cdsDados.Active := False;
          cdsDados.Active := True;
        end);
    end);

end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  edtQuantidade.Text := inttostr(20);
  edtDescricao.Text := 'TESTE DE SISTEMA...';

  lblAnonima.Caption := 'Thread parada';
  lblTask.Caption := 'Thread parada';
end;

procedure TfrmPrincipal.InserirRegistros;
var
  i: Integer;
begin
  // crio o data set
  if cdsDados.Active then
    cdsDados.EmptyDataSet
  else
    cdsDados.CreateDataSet;

  // insert de dados..
  for i := 0 to StrToInt(edtQuantidade.Text) - 1 do
  begin
    Sleep(500);
    cdsDados.Insert;
    cdsDados.FieldByName('ID').AsInteger := i;
    cdsDados.FieldByName('DESCRICAO').AsString := edtDescricao.Text;
    cdsDados.Post;

    if i = StrToInt(edtQuantidade.Text) - 1 then
      lblTask.Caption := 'Thread Finalizada';
  end;

end;

procedure TfrmPrincipal.InserirRegistros2;
var
  i: Integer;
begin
  // crio o data set
  if cdsDados2.Active then
    cdsDados2.EmptyDataSet
  else
    cdsDados2.CreateDataSet;

  // insert de dados..
  for i := 0 to StrToInt(edtQuantidade.Text) - 1 do
  begin
    Sleep(500);
    cdsDados2.Insert;
    cdsDados2.FieldByName('ID').AsInteger := i;
    cdsDados2.FieldByName('DESCRICAO').AsString := edtDescricao.Text;
    cdsDados2.Post;

    if i = StrToInt(edtQuantidade.Text) - 1 then
      lblAnonima.Caption := 'Thread Finalizada';
  end;

end;

end.
