PGDMP     6                    {           Majster    15.2    15.2 $    5           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            6           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            7           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            8           1262    17669    Majster    DATABASE     |   CREATE DATABASE "Majster" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Polish_Poland.1250';
    DROP DATABASE "Majster";
                Majster    false            �            1259    17670    users    TABLE     �  CREATE TABLE public.users (
    user_id bigint NOT NULL,
    user_name character varying(100) NOT NULL,
    user_surname character varying(100) NOT NULL,
    user_email character varying(100) NOT NULL,
    user_login character varying(100) NOT NULL,
    user_password character varying(100) NOT NULL,
    user_role character varying(100) DEFAULT USER NOT NULL,
    user_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    17677    users_user_id_seq    SEQUENCE     z   CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          postgres    false    214            9           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          postgres    false    215            �            1259    17678    alerts    TABLE       CREATE TABLE public.alerts (
    alert_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    alert_title character varying(100) NOT NULL,
    alert_who_add_id bigint NOT NULL,
    alert_details character varying(10000) NOT NULL,
    alert_add_date timestamp with time zone NOT NULL,
    alert_exist boolean DEFAULT true NOT NULL,
    alert_machine_id bigint DEFAULT 0,
    alert_status character varying DEFAULT 'Brak'::character varying NOT NULL,
    alert_repairer_id bigint DEFAULT 0
);
    DROP TABLE public.alerts;
       public         heap    postgres    false    215            �            1259    17688    machines    TABLE     
  CREATE TABLE public.machines (
    machine_id bigint NOT NULL,
    machine_name character varying(100) NOT NULL,
    machine_type character varying(100) NOT NULL,
    machine_status character varying(100) NOT NULL,
    machine_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.machines;
       public         heap    postgres    false            �            1259    17692    machines_machine_id_seq    SEQUENCE     �   CREATE SEQUENCE public.machines_machine_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.machines_machine_id_seq;
       public          postgres    false    217            :           0    0    machines_machine_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.machines_machine_id_seq OWNED BY public.machines.machine_id;
          public          postgres    false    218            �            1259    17693    realize_tasks    TABLE     �   CREATE TABLE public.realize_tasks (
    realize_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    realize_user_id bigint NOT NULL,
    realize_machine_id bigint NOT NULL,
    realize_task_id bigint NOT NULL
);
 !   DROP TABLE public.realize_tasks;
       public         heap    postgres    false    215            �            1259    17697    services    TABLE     #  CREATE TABLE public.services (
    service_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    service_title character varying(100) NOT NULL,
    service_machine_id bigint NOT NULL,
    service_details character varying(10000) NOT NULL,
    service_start_date timestamp with time zone NOT NULL,
    service_end_date timestamp with time zone,
    service_exist boolean DEFAULT true NOT NULL,
    service_status character varying(20) DEFAULT 'Nie zaczęte'::character varying,
    service_user_id bigint DEFAULT 0
);
    DROP TABLE public.services;
       public         heap    postgres    false    218            �            1259    17706    tasks    TABLE     �  CREATE TABLE public.tasks (
    task_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    task_title character varying(100) NOT NULL,
    task_details character varying(10000) NOT NULL,
    task_add_date timestamp with time zone NOT NULL,
    task_start_date timestamp with time zone,
    task_end_date timestamp with time zone,
    task_exist boolean DEFAULT true NOT NULL,
    task_start_date_by_user timestamp with time zone
);
    DROP TABLE public.tasks;
       public         heap    postgres    false    218            �           2604    17713    machines machine_id    DEFAULT     z   ALTER TABLE ONLY public.machines ALTER COLUMN machine_id SET DEFAULT nextval('public.machines_machine_id_seq'::regclass);
 B   ALTER TABLE public.machines ALTER COLUMN machine_id DROP DEFAULT;
       public          postgres    false    218    217            z           2604    17714    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    215    214            -          0    17678    alerts 
   TABLE DATA           �   COPY public.alerts (alert_id, alert_title, alert_who_add_id, alert_details, alert_add_date, alert_exist, alert_machine_id, alert_status, alert_repairer_id) FROM stdin;
    public          postgres    false    216   �/       .          0    17688    machines 
   TABLE DATA           i   COPY public.machines (machine_id, machine_name, machine_type, machine_status, machine_exist) FROM stdin;
    public          postgres    false    217   �2       0          0    17693    realize_tasks 
   TABLE DATA           i   COPY public.realize_tasks (realize_id, realize_user_id, realize_machine_id, realize_task_id) FROM stdin;
    public          postgres    false    219   	3       1          0    17697    services 
   TABLE DATA           �   COPY public.services (service_id, service_title, service_machine_id, service_details, service_start_date, service_end_date, service_exist, service_status, service_user_id) FROM stdin;
    public          postgres    false    220   33       2          0    17706    tasks 
   TABLE DATA           �   COPY public.tasks (task_id, task_title, task_details, task_add_date, task_start_date, task_end_date, task_exist, task_start_date_by_user) FROM stdin;
    public          postgres    false    221   w5       +          0    17670    users 
   TABLE DATA              COPY public.users (user_id, user_name, user_surname, user_email, user_login, user_password, user_role, user_exist) FROM stdin;
    public          postgres    false    214   �7       ;           0    0    machines_machine_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.machines_machine_id_seq', 110, true);
          public          postgres    false    218            <           0    0    users_user_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.users_user_id_seq', 110, true);
          public          postgres    false    215            �           2606    17716    alerts alerts_pkay 
   CONSTRAINT     V   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkay PRIMARY KEY (alert_id);
 <   ALTER TABLE ONLY public.alerts DROP CONSTRAINT alerts_pkay;
       public            postgres    false    216            �           2606    17718    machines machines_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (machine_id);
 @   ALTER TABLE ONLY public.machines DROP CONSTRAINT machines_pkey;
       public            postgres    false    217            �           2606    17720    realize_tasks mut_pkay 
   CONSTRAINT     \   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT mut_pkay PRIMARY KEY (realize_id);
 @   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT mut_pkay;
       public            postgres    false    219            �           2606    17722    services serwic_pkay 
   CONSTRAINT     Z   ALTER TABLE ONLY public.services
    ADD CONSTRAINT serwic_pkay PRIMARY KEY (service_id);
 >   ALTER TABLE ONLY public.services DROP CONSTRAINT serwic_pkay;
       public            postgres    false    220            �           2606    17724    tasks tasks_pkay 
   CONSTRAINT     S   ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkay PRIMARY KEY (task_id);
 :   ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_pkay;
       public            postgres    false    221            �           2606    17726    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    214            �           2606    17727    services machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT machine_fkay FOREIGN KEY (service_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 ?   ALTER TABLE ONLY public.services DROP CONSTRAINT machine_fkay;
       public          postgres    false    3216    217    220            �           2606    17732    realize_tasks machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT machine_fkay FOREIGN KEY (realize_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 D   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT machine_fkay;
       public          postgres    false    3216    217    219            �           2606    17752    alerts machine_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT machine_fkey FOREIGN KEY (alert_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 =   ALTER TABLE ONLY public.alerts DROP CONSTRAINT machine_fkey;
       public          postgres    false    216    3216    217            �           2606    17737    realize_tasks taask_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT taask_fkay FOREIGN KEY (realize_task_id) REFERENCES public.tasks(task_id) NOT VALID;
 B   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT taask_fkay;
       public          postgres    false    3222    221    219            �           2606    17742    alerts user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT user_fkay FOREIGN KEY (alert_who_add_id) REFERENCES public.users(user_id) NOT VALID;
 :   ALTER TABLE ONLY public.alerts DROP CONSTRAINT user_fkay;
       public          postgres    false    214    216    3212            �           2606    17747    realize_tasks user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT user_fkay FOREIGN KEY (realize_user_id) REFERENCES public.users(user_id) NOT VALID;
 A   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT user_fkay;
       public          postgres    false    219    214    3212            -   �  x�}T9��0��S�K13wRt�>E� i�0��lː�V ��]R��+�ZƖ<���S�{��oZ�m�m2�PF�\<Q��-f���)E���Q���%�+mP�^���&���w!R̟`0��ם�\�����A��r���4[80}M�w؟�
Sė�FP̬�Rm�:�Dͱ��m��Q�dޠ9u�8���0���}8����sU�a��8��I�g7x��j�W�/�:�b�����������ͮl/�#�-_�S�קh�u'>E�Ǘ�P�e�~��B�߆��&�8�����B����,��71���@��?Մ~����	"�]��
�M��>�&NA� ݊/�I� ܁�b�Np5��Z:�����[�cz�S�X-Ȅ���b���Ց�G�}�����H ����F6�cN��!Rɑ���T�5���8wB:�	K�ݰ�"�Q���F��:=ǳ^�:[�D������($&�ލS:DNCa��Z ���v�\8i�8QtT�o�z�H�9�mZ���X�~ۅ�_��~�:6_�]/���9��&��y�[V�x�Uy�{��gNb):t�B�NX�E�Ne�[S�F��wU;��xr9�u^S�(t�$ƚQ$P`���&DF�Ͼ�,�G��q�Qh1C�a��ѫ�d�Z�G<��      .   g   x�3�t�s6�,��N,�N�.(J,�K�,�24��H,��K/�ϋ7q7�,�,H�AWd�雙nj�K,G�42I*�&�+�d�s�T�+��S��Y
T���� ��)�      0      x�344�4�42�444������ 5�      1   4  x���݊�0����}����9
��Y�KHI`���^���^ɩcG��AX��?�9c��5��:�u��@Q'��
}�6i�h�8$��uy<�o�˹?�u�&�Lʅz����D� x<�Qh`���^y�w��e�]Ҙ�V��v��QB�|�	��n�N������jR��nI䙵�B.�֐��&�m�T|W�Q�o.����ec�ܧRTP֛n�WN�e>�9�~���̟����^���E�?��I�&[�<���b�U�[��s��<g���M����d���h��j��a�\T�,��e��Ѫ���kC�����'G��%n��]�; /�dc҆K�#tڕ�eE�杼��tk&��Y���X�rz�O\E]�bks��ﺓQ���VZ�?B]�j��{{�>�O��-i�/��)W�8mK��1���}��tɚ	��,����bh��s�JwZ8_�u���9S+\�;���q�A!�RWG�QE�!�>�ˇt���&'9^��1r�=Q����y�
,�r��6K.��-���V�w�u�o���      2   I  x��U�n�0<�_��"�^��;�R�q�I����r�8������C��tL���:L�#�	���R�T%A��ʕ2�.�Q��	P�����6�~�mn>��7����簧Q���"�g�J��������EP����|=ߦ��f�ؽ��XYAc��z2A<�����و�4�M�}	0yVcąv��s��G���"vr����>��<�čR�i���e��k��j'�U8J�!WT(R�P@Sr�� ���|���e����Z�]	Ds��j�=����,�1����ZFcT7�=밣{ 1�9��D��t(	1W�`	���� I{y�}vB�WڹʎE�]Eǰ��|у�|{6�q�y8߯�\ɵ�_��MGe�^͉U$`����I#�Rs	�}�yS��qAҍ��c�^`�sh�����B�+6��w���2T��t'_0��p�G�YWSt���5N?0����Un�f!#��}����}{��������U�	Х�7��.}���	��a�
��sW��Rڮ��
Y���&�B��� /_���y�Y\Lц�R�ւ���b�LQ�A��� �o��׆{      +   �   x�u�M
�@�יÔ�?p׍ �ڥ�PG秵3�ԣx�e��E�<����0[z
	M�y�$��i�-oOZpl;4P8���E���(U\N�%����u�E�PIU�л?F�
Tg� =�q�0hy����c�u��4�?}³4�?E�hÜ��g:� k��b�= ����G-�_Jh� {q��<Kӑ�%��&��1a�} ����     