--------------------------------------------------------
--  Arquivo criado - Quinta-feira-Novembro-04-2021   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function VALIDA_CNPJ
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "VALIDA_CNPJ" (v_cnpj number)
return int
is
--set serveroutput on
--declare
--v_cnpj number := 07605567000130;--23;--;2054;--234;
soma number := 0;
v_contador number := 2;
begin
    if length(v_cnpj) > 14 or length(v_cnpj) < 3 then
        return 0;
        --sys.DBMS_OUTPUT.put_line('cnpj invalidacao');
    end if;
    --validar primeiro digito DV
    for i in reverse 1..length(v_cnpj)-2 loop
        soma := soma + substr(v_cnpj, i,1)*v_contador;
        if v_contador = 9 then
            v_contador := 2;
        else
            v_contador := v_contador +1;
        end if;
    end loop;
    soma := mod(soma,11);
    if soma < 2 then
        soma := 0;
    else
        soma := 11-soma;
    end if;
    --sys.DBMS_OUTPUT.put_line(soma);
    --sys.DBMS_OUTPUT.put_line('pri dig verif '||substr(v_cnpj,-2,1));
    if soma != substr(v_cnpj,-2,1) then
        return 0;
        --sys.DBMS_OUTPUT.put_line('falha primeira validacao');
    end if;
    soma := 0;
    v_contador := 2;
    --validar segundo digito DV
    for i in reverse 1..length(v_cnpj)-1 loop
        soma := soma + substr(v_cnpj, i,1)*v_contador;
        if v_contador = 9 then
            v_contador := 2;
        else
            v_contador := v_contador +1;
        end if;
    end loop;
    soma := mod(soma,11);
    if soma < 2 then
        soma := 0;
    else
        soma := 11-soma;
    end if;
    --sys.DBMS_OUTPUT.put_line(soma);
    if soma != substr(v_cnpj,-1,1) then
        return 0;
        --sys.DBMS_OUTPUT.put_line('falha segunda validacao');
    end if;
    --sys.DBMS_OUTPUT.put_line('valido');
    return v_cnpj;
end;

/
--------------------------------------------------------
--  DDL for Function VALIDA_CPF
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "VALIDA_CPF" (v_cpf number)
return int
is
--set serveroutput on
--declare
--v_cpf number := 52998224725;--234;
soma number := 0;
v_contador number := 2;
begin
    if length(v_cpf) > 11 or length(v_cpf) < 3 then
        return 0;
        --sys.DBMS_OUTPUT.put_line('cnpj invalidacao');
    end if;
    --validar primeiro digito DV
    for i in reverse 1..length(v_cpf)-2 loop
        soma := soma + substr(v_cpf, i,1)*v_contador;
        v_contador := v_contador +1;
    end loop;
    soma := mod(soma*10,11);
    if soma = 10 or soma = 11 then
        soma := 0;
    end if;
    --sys.DBMS_OUTPUT.put_line(soma);
    --sys.DBMS_OUTPUT.put_line('pri dig verif '||substr(v_cpf,-2,1));
    if soma != substr(v_cpf,-2,1) then
        return 0;
        --sys.DBMS_OUTPUT.put_line('falha primeira validacao');
    end if;
    soma := 0;
    v_contador := 2;
    --validar segundo digito DV
    for i in reverse 1..length(v_cpf)-1 loop
        soma := soma + substr(v_cpf, i,1)*v_contador;
        v_contador := v_contador +1;
    end loop;
    soma := mod(soma*10,11);
    if soma = 10 or soma = 11 then
        soma := 0;
    end if;
    --sys.DBMS_OUTPUT.put_line(soma);
    if soma != substr(v_cpf,-1,1) then
        return 0;
        --sys.DBMS_OUTPUT.put_line('falha segunda validacao');
    end if;
    --sys.DBMS_OUTPUT.put_line('valido');
    return v_cpf;
end;

/
