PGDMP     '                    {           Majster    15.2    15.2     
           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16518    Majster    DATABASE     |   CREATE DATABASE "Majster" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Polish_Poland.1250';
    DROP DATABASE "Majster";
                Majster    false            �            1259    16802    alerts    TABLE     P  CREATE TABLE public.alerts (
    alert_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    alert_title character varying(100) NOT NULL,
    alert_who_add_id bigint NOT NULL,
    alert_details character varying(10000) NOT NULL,
    alert_add_date date NOT NULL,
    alert_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.alerts;
       public         heap    postgres    false                      0    16802    alerts 
   TABLE DATA           u   COPY public.alerts (alert_id, alert_title, alert_who_add_id, alert_details, alert_add_date, alert_exist) FROM stdin;
    public          postgres    false    216   �       w           2606    16832    alerts alerts_pkay 
   CONSTRAINT     V   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkay PRIMARY KEY (alert_id);
 <   ALTER TABLE ONLY public.alerts DROP CONSTRAINT alerts_pkay;
       public            postgres    false    216            x           2606    16858    alerts user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT user_fkay FOREIGN KEY (alert_who_add_id) REFERENCES public.users(user_id) NOT VALID;
 :   ALTER TABLE ONLY public.alerts DROP CONSTRAINT user_fkay;
       public          postgres    false    216               K  x�m��R�0�ׇ���)	���k]��ͩ	�R�I�����#8����t��'�߹�9��2*]S�Z�+J�dyF>5����Sx�[54�H<��w<5D�G��_���.�VpV�����Aݒ3�o����-�� el�5�� R�=��`g	vB�4c�b'h�-3��\�6�1�������]�2�=���b&��
?)B�>�(m��^��y^�[7�p>�~j�ph��l��ݬ!��O�a^�HuVѱ�:M�2��E�!ʮ{Y��~�Fcٴ~$򮑶�W{1���T1�ǖ����<��/�C���2�wY�� �$һ     