PGDMP         +                {           Majster    15.2    15.2 #    *           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            +           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ,           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            -           1262    16518    Majster    DATABASE     |   CREATE DATABASE "Majster" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Polish_Poland.1250';
    DROP DATABASE "Majster";
                Majster    false            �            1259    16519    users    TABLE     k  CREATE TABLE public.users (
    user_id bigint NOT NULL,
    user_name character varying(100) NOT NULL,
    user_surname character varying(100) NOT NULL,
    user_email character varying(100) NOT NULL,
    user_login character varying(100) NOT NULL,
    user_password character varying(100) NOT NULL,
    user_role character varying(100) DEFAULT USER NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    16525    users_user_id_seq    SEQUENCE     z   CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          postgres    false    214            .           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          postgres    false    215            �            1259    16526    alerts    TABLE     !  CREATE TABLE public.alerts (
    alert_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    alert_title character varying(100) NOT NULL,
    alert_who_add_id bigint NOT NULL,
    alert_details character varying(10000) NOT NULL,
    alert_add_date date NOT NULL
);
    DROP TABLE public.alerts;
       public         heap    postgres    false    215            �            1259    16536    machines    TABLE     �   CREATE TABLE public.machines (
    machine_id bigint NOT NULL,
    machine_name character varying(100) NOT NULL,
    machine_type character varying(100) NOT NULL,
    machine_status character varying(100) NOT NULL
);
    DROP TABLE public.machines;
       public         heap    postgres    false            �            1259    16539    machines_machine_id_seq    SEQUENCE     �   CREATE SEQUENCE public.machines_machine_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.machines_machine_id_seq;
       public          postgres    false    218            /           0    0    machines_machine_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.machines_machine_id_seq OWNED BY public.machines.machine_id;
          public          postgres    false    219            �            1259    16532    realize_tasks    TABLE     �   CREATE TABLE public.realize_tasks (
    realize_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    realize_user_id bigint NOT NULL,
    realize_machine_id bigint NOT NULL,
    realize_task_id bigint NOT NULL
);
 !   DROP TABLE public.realize_tasks;
       public         heap    postgres    false    215            �            1259    16540    services    TABLE     P  CREATE TABLE public.services (
    service_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    service_title character varying(100) NOT NULL,
    service_machine_id bigint NOT NULL,
    service_details character varying(10000) NOT NULL,
    service_start_date date NOT NULL,
    service_end_date date
);
    DROP TABLE public.services;
       public         heap    postgres    false    219            �            1259    16546    tasks    TABLE     7  CREATE TABLE public.tasks (
    task_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    task_title character varying(100) NOT NULL,
    task_details character varying(10000) NOT NULL,
    task_add_date date NOT NULL,
    task_start_date date NOT NULL,
    task_end_date date
);
    DROP TABLE public.tasks;
       public         heap    postgres    false    219            ~           2604    16552    machines machine_id    DEFAULT     z   ALTER TABLE ONLY public.machines ALTER COLUMN machine_id SET DEFAULT nextval('public.machines_machine_id_seq'::regclass);
 B   ALTER TABLE public.machines ALTER COLUMN machine_id DROP DEFAULT;
       public          postgres    false    219    218            z           2604    16553    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    215    214            "          0    16526    alerts 
   TABLE DATA           h   COPY public.alerts (alert_id, alert_title, alert_who_add_id, alert_details, alert_add_date) FROM stdin;
    public          postgres    false    216   +       $          0    16536    machines 
   TABLE DATA           Z   COPY public.machines (machine_id, machine_name, machine_type, machine_status) FROM stdin;
    public          postgres    false    218   F+       #          0    16532    realize_tasks 
   TABLE DATA           i   COPY public.realize_tasks (realize_id, realize_user_id, realize_machine_id, realize_task_id) FROM stdin;
    public          postgres    false    217   z+       &          0    16540    services 
   TABLE DATA           �   COPY public.services (service_id, service_title, service_machine_id, service_details, service_start_date, service_end_date) FROM stdin;
    public          postgres    false    220   �+       '          0    16546    tasks 
   TABLE DATA           q   COPY public.tasks (task_id, task_title, task_details, task_add_date, task_start_date, task_end_date) FROM stdin;
    public          postgres    false    221   �+                  0    16519    users 
   TABLE DATA           s   COPY public.users (user_id, user_name, user_surname, user_email, user_login, user_password, user_role) FROM stdin;
    public          postgres    false    214   .,       0           0    0    machines_machine_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.machines_machine_id_seq', 5, true);
          public          postgres    false    219            1           0    0    users_user_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.users_user_id_seq', 13, true);
          public          postgres    false    215            �           2606    16555    alerts alerts_pkay 
   CONSTRAINT     V   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkay PRIMARY KEY (alert_id);
 <   ALTER TABLE ONLY public.alerts DROP CONSTRAINT alerts_pkay;
       public            postgres    false    216            �           2606    16557    machines machines_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (machine_id);
 @   ALTER TABLE ONLY public.machines DROP CONSTRAINT machines_pkey;
       public            postgres    false    218            �           2606    16559    realize_tasks mut_pkay 
   CONSTRAINT     \   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT mut_pkay PRIMARY KEY (realize_id);
 @   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT mut_pkay;
       public            postgres    false    217            �           2606    16561    services serwic_pkay 
   CONSTRAINT     Z   ALTER TABLE ONLY public.services
    ADD CONSTRAINT serwic_pkay PRIMARY KEY (service_id);
 >   ALTER TABLE ONLY public.services DROP CONSTRAINT serwic_pkay;
       public            postgres    false    220            �           2606    16563    tasks tasks_pkay 
   CONSTRAINT     S   ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkay PRIMARY KEY (task_id);
 :   ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_pkay;
       public            postgres    false    221            �           2606    16565    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    214            �           2606    16566    services machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT machine_fkay FOREIGN KEY (service_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 ?   ALTER TABLE ONLY public.services DROP CONSTRAINT machine_fkay;
       public          postgres    false    218    220    3208            �           2606    16571    realize_tasks machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT machine_fkay FOREIGN KEY (realize_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 D   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT machine_fkay;
       public          postgres    false    217    3208    218            �           2606    16576    realize_tasks taask_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT taask_fkay FOREIGN KEY (realize_task_id) REFERENCES public.tasks(task_id) NOT VALID;
 B   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT taask_fkay;
       public          postgres    false    217    3212    221            �           2606    16581    alerts user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT user_fkay FOREIGN KEY (alert_who_add_id) REFERENCES public.users(user_id) NOT VALID;
 :   ALTER TABLE ONLY public.alerts DROP CONSTRAINT user_fkay;
       public          postgres    false    216    3202    214            �           2606    16586    realize_tasks user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT user_fkay FOREIGN KEY (realize_user_id) REFERENCES public.users(user_id) NOT VALID;
 A   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT user_fkay;
       public          postgres    false    3202    214    217            "      x�3�,I-.�4�RFƺ�@����� v��      $   $   x�3�t�s6�,��N,�N�L�.�,�K����� v��      #      x������ � �      &   "   x�3�,I-.�4�PFFƺ�@������� Ϣ�      '   U   x�3�LL).NL�L,N)N�4202�50�52C0�9c��L8��S���$T�(�`��Tr��T&g%r��� � gZ���\1z\\\ ��          1  x�MRKr� ]ˇ�ߝ7�t�M;ɲ�`��3L|�ާ�*?�Y��$=	�!��Np�������یS=	P.d�e�J��������3?��006\+�03;oPt[0j�[xC���
.q�!zE�<�L�;8���e/���e�i���ٞ3Di$��0lBnB�F�Ў*�q��-�[�c�,A�M��aQl�u�����:�u�{��w�Ү�S�cF�9�e�
���h�Ң�h��-�2!��☬,6���:m����C:�@˾��╚���R6�u�0��?�����>2��     