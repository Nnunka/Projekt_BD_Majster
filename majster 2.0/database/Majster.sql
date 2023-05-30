PGDMP     1    "                {           Majster    15.2    15.2 #    1           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            2           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            3           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            4           1262    16518    Majster    DATABASE     |   CREATE DATABASE "Majster" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Polish_Poland.1250';
    DROP DATABASE "Majster";
                Majster    false            �            1259    17228    users    TABLE     �  CREATE TABLE public.users (
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
       public         heap    postgres    false            �            1259    17235    users_user_id_seq    SEQUENCE     z   CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          postgres    false    214            5           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          postgres    false    215            �            1259    17236    alerts    TABLE     d  CREATE TABLE public.alerts (
    alert_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    alert_title character varying(100) NOT NULL,
    alert_who_add_id bigint NOT NULL,
    alert_details character varying(10000) NOT NULL,
    alert_add_date timestamp with time zone NOT NULL,
    alert_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.alerts;
       public         heap    postgres    false    215            �            1259    17243    machines    TABLE     
  CREATE TABLE public.machines (
    machine_id bigint NOT NULL,
    machine_name character varying(100) NOT NULL,
    machine_type character varying(100) NOT NULL,
    machine_status character varying(100) NOT NULL,
    machine_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.machines;
       public         heap    postgres    false            �            1259    17247    machines_machine_id_seq    SEQUENCE     �   CREATE SEQUENCE public.machines_machine_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.machines_machine_id_seq;
       public          postgres    false    217            6           0    0    machines_machine_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.machines_machine_id_seq OWNED BY public.machines.machine_id;
          public          postgres    false    218            �            1259    17248    realize_tasks    TABLE     �   CREATE TABLE public.realize_tasks (
    realize_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    realize_user_id bigint NOT NULL,
    realize_machine_id bigint NOT NULL,
    realize_task_id bigint NOT NULL
);
 !   DROP TABLE public.realize_tasks;
       public         heap    postgres    false    215            �            1259    17252    services    TABLE     #  CREATE TABLE public.services (
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
       public         heap    postgres    false    218            �            1259    17261    tasks    TABLE     �  CREATE TABLE public.tasks (
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
       public         heap    postgres    false    218                       2604    17496    machines machine_id    DEFAULT     z   ALTER TABLE ONLY public.machines ALTER COLUMN machine_id SET DEFAULT nextval('public.machines_machine_id_seq'::regclass);
 B   ALTER TABLE public.machines ALTER COLUMN machine_id DROP DEFAULT;
       public          postgres    false    218    217            z           2604    17497    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    215    214            )          0    17236    alerts 
   TABLE DATA           u   COPY public.alerts (alert_id, alert_title, alert_who_add_id, alert_details, alert_add_date, alert_exist) FROM stdin;
    public          postgres    false    216   �-       *          0    17243    machines 
   TABLE DATA           i   COPY public.machines (machine_id, machine_name, machine_type, machine_status, machine_exist) FROM stdin;
    public          postgres    false    217   /       ,          0    17248    realize_tasks 
   TABLE DATA           i   COPY public.realize_tasks (realize_id, realize_user_id, realize_machine_id, realize_task_id) FROM stdin;
    public          postgres    false    219   {/       -          0    17252    services 
   TABLE DATA           �   COPY public.services (service_id, service_title, service_machine_id, service_details, service_start_date, service_end_date, service_exist, service_status, service_user_id) FROM stdin;
    public          postgres    false    220   �/       .          0    17261    tasks 
   TABLE DATA           �   COPY public.tasks (task_id, task_title, task_details, task_add_date, task_start_date, task_end_date, task_exist, task_start_date_by_user) FROM stdin;
    public          postgres    false    221   �0       '          0    17228    users 
   TABLE DATA              COPY public.users (user_id, user_name, user_surname, user_email, user_login, user_password, user_role, user_exist) FROM stdin;
    public          postgres    false    214   &3       7           0    0    machines_machine_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.machines_machine_id_seq', 83, true);
          public          postgres    false    218            8           0    0    users_user_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.users_user_id_seq', 69, true);
          public          postgres    false    215            �           2606    17271    alerts alerts_pkay 
   CONSTRAINT     V   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkay PRIMARY KEY (alert_id);
 <   ALTER TABLE ONLY public.alerts DROP CONSTRAINT alerts_pkay;
       public            postgres    false    216            �           2606    17273    machines machines_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (machine_id);
 @   ALTER TABLE ONLY public.machines DROP CONSTRAINT machines_pkey;
       public            postgres    false    217            �           2606    17275    realize_tasks mut_pkay 
   CONSTRAINT     \   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT mut_pkay PRIMARY KEY (realize_id);
 @   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT mut_pkay;
       public            postgres    false    219            �           2606    17277    services serwic_pkay 
   CONSTRAINT     Z   ALTER TABLE ONLY public.services
    ADD CONSTRAINT serwic_pkay PRIMARY KEY (service_id);
 >   ALTER TABLE ONLY public.services DROP CONSTRAINT serwic_pkay;
       public            postgres    false    220            �           2606    17279    tasks tasks_pkay 
   CONSTRAINT     S   ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkay PRIMARY KEY (task_id);
 :   ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_pkay;
       public            postgres    false    221            �           2606    17281    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    214            �           2606    17282    services machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT machine_fkay FOREIGN KEY (service_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 ?   ALTER TABLE ONLY public.services DROP CONSTRAINT machine_fkay;
       public          postgres    false    220    3213    217            �           2606    17287    realize_tasks machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT machine_fkay FOREIGN KEY (realize_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 D   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT machine_fkay;
       public          postgres    false    219    3213    217            �           2606    17292    realize_tasks taask_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT taask_fkay FOREIGN KEY (realize_task_id) REFERENCES public.tasks(task_id) NOT VALID;
 B   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT taask_fkay;
       public          postgres    false    221    219    3219            �           2606    17297    alerts user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT user_fkay FOREIGN KEY (alert_who_add_id) REFERENCES public.users(user_id) NOT VALID;
 :   ALTER TABLE ONLY public.alerts DROP CONSTRAINT user_fkay;
       public          postgres    false    214    3209    216            �           2606    17302    realize_tasks user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT user_fkay FOREIGN KEY (realize_user_id) REFERENCES public.users(user_id) NOT VALID;
 A   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT user_fkay;
       public          postgres    false    219    214    3209            )   R  x����n�0���)|��HB�������.�m�Ʉ�q��G��^3�����A?���`3c%���@�E�Rb$��	�1�
�.��w!�9Um�aI����9K����G��B�VH�PWuC퉀��C5U��65�Ԝ�C�W��c�g����cɍ���J;��l��xO6��muvO0�>�'�vo�7��<�`��vL�C����������*��oNH���3�Mlx��h�
�t���N\|�i`���&~�b�(���Vz̉�8���k~��(��W2���4���Rk�X}����6�t�rq�?��h�]�Љ,��H�Ͼ�y���      *   h   x�34���L75s�.H,O,�N�t��L�I�L�2�t�s6�,�����gs�p�sz$e楗��ś�q�W u��12���������Y3� F��� �&�      ,      x�37�4�4�43����� �      -     x����j�0����Y���"���F��9��S��5�(a��?�c�-ĔS�	Ⱥhr=b(uB��p@%U�$x���5v�7(t��"p������Y�}P�������e��`;֒�D<>Nq��#`��o0�a���(�:�)�\��>h�'��]K���
$��m��hj��W6����Ԑ^�6��@9�_���!���l^Lh�&$2գ~!Kjٷ�Y���Ɩ����~C{�H�GM���?Ʈ�~�)�      .   \  x��Vˮ�0]�_��
+���ݑ��� ���H���I}.���AǏ�8����ۮ��w���Y}�3Q���ڝ1�L�䲍@4*��>k�r�:��fO��14�̫�̠���g�@���~��IB�K+Hi�Q���R�s0�3F&�?X�n�3�	G�Eյ�*��v���L)k�Q�}�jIKU���bv��G����~��54s�s$���1������Yl����F�'�d� &}�~�jIt	������+�E��������>y�IzԵC��I:�CLe[yn�VH㽺=�3��k��� ���a��~7��0[�ޤ]�5PZnhb��4e�831)�88��mC:bl�W��F~-3��`�K���,B����NH>m�^�hj�Q�^�����J?�wn�b�@G�a♒ �F�у���^W);�k/Ӳ��G��P~8C��z�%,�>0����l�L�4��T?w���A+g�v�U�-u�-Igv%{$��ٕ�qӌ�67e�Lv[��_2����o��䚽��"� s��#c���Z)X5$(�좳�)r�A�qӄ�nS��]6��/4M��O�      '   '  x�mQKN�0];����]7H6H3K6�&@��5iTM��}��U�E�g���IZxE/�Bx�t��v�4F�����Tr��3*8L�z�pFU���7ws�f
sK&�D��%��%���r�N��,�8>��$��\4��97��� .�M$GP���e�M�w0h���*y�>�Vº�>�L&�m7ΖŎ�sj�Vj�`DG!lQ(�\AՈP�-V��V�6�?��ʿ�Z��ſ�n������%Jn{�w��R.�u�J����na	�R��Ň�4����Ʒ�����D     