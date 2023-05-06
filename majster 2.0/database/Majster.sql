PGDMP         )                {           Majster    15.2    15.2 #    *           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
          public          postgres    false    215            �            1259    16526    alerts    TABLE       CREATE TABLE public.alerts (
    alert_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    title character varying(100) NOT NULL,
    who_add bigint NOT NULL,
    details character varying(10000) NOT NULL,
    date_add date NOT NULL
);
    DROP TABLE public.alerts;
       public         heap    postgres    false    215            �            1259    16532    ma_us_ts    TABLE     �   CREATE TABLE public.ma_us_ts (
    mut_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    user_id bigint NOT NULL,
    machine_id bigint NOT NULL,
    task_id bigint NOT NULL
);
    DROP TABLE public.ma_us_ts;
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
          public          postgres    false    219            �            1259    16540    serwice    TABLE     *  CREATE TABLE public.serwice (
    serwic_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    serwic_title character varying(100) NOT NULL,
    machine bigint NOT NULL,
    details character varying(10000) NOT NULL,
    date_start date NOT NULL,
    date_end date
);
    DROP TABLE public.serwice;
       public         heap    postgres    false    219            �            1259    16546    tasks    TABLE     !  CREATE TABLE public.tasks (
    task_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    title character varying(100) NOT NULL,
    details character varying(10000) NOT NULL,
    date_add date NOT NULL,
    date_to_end date,
    date_start date NOT NULL
);
    DROP TABLE public.tasks;
       public         heap    postgres    false    219            ~           2604    16552    machines machine_id    DEFAULT     z   ALTER TABLE ONLY public.machines ALTER COLUMN machine_id SET DEFAULT nextval('public.machines_machine_id_seq'::regclass);
 B   ALTER TABLE public.machines ALTER COLUMN machine_id DROP DEFAULT;
       public          postgres    false    219    218            z           2604    16553    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    215    214            "          0    16526    alerts 
   TABLE DATA           M   COPY public.alerts (alert_id, title, who_add, details, date_add) FROM stdin;
    public          postgres    false    216   �)       #          0    16532    ma_us_ts 
   TABLE DATA           H   COPY public.ma_us_ts (mut_id, user_id, machine_id, task_id) FROM stdin;
    public          postgres    false    217   �)       $          0    16536    machines 
   TABLE DATA           Z   COPY public.machines (machine_id, machine_name, machine_type, machine_status) FROM stdin;
    public          postgres    false    218   �)       &          0    16540    serwice 
   TABLE DATA           b   COPY public.serwice (serwic_id, serwic_title, machine, details, date_start, date_end) FROM stdin;
    public          postgres    false    220   *       '          0    16546    tasks 
   TABLE DATA           [   COPY public.tasks (task_id, title, details, date_add, date_to_end, date_start) FROM stdin;
    public          postgres    false    221   .*                  0    16519    users 
   TABLE DATA           s   COPY public.users (user_id, user_name, user_surname, user_email, user_login, user_password, user_role) FROM stdin;
    public          postgres    false    214   K*       0           0    0    machines_machine_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.machines_machine_id_seq', 1, false);
          public          postgres    false    219            1           0    0    users_user_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.users_user_id_seq', 12, true);
          public          postgres    false    215            �           2606    16555    alerts alerts_pkay 
   CONSTRAINT     V   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkay PRIMARY KEY (alert_id);
 <   ALTER TABLE ONLY public.alerts DROP CONSTRAINT alerts_pkay;
       public            postgres    false    216            �           2606    16557    machines machines_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (machine_id);
 @   ALTER TABLE ONLY public.machines DROP CONSTRAINT machines_pkey;
       public            postgres    false    218            �           2606    16559    ma_us_ts mut_pkay 
   CONSTRAINT     S   ALTER TABLE ONLY public.ma_us_ts
    ADD CONSTRAINT mut_pkay PRIMARY KEY (mut_id);
 ;   ALTER TABLE ONLY public.ma_us_ts DROP CONSTRAINT mut_pkay;
       public            postgres    false    217            �           2606    16561    serwice serwic_pkay 
   CONSTRAINT     X   ALTER TABLE ONLY public.serwice
    ADD CONSTRAINT serwic_pkay PRIMARY KEY (serwic_id);
 =   ALTER TABLE ONLY public.serwice DROP CONSTRAINT serwic_pkay;
       public            postgres    false    220            �           2606    16563    tasks tasks_pkay 
   CONSTRAINT     S   ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkay PRIMARY KEY (task_id);
 :   ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_pkay;
       public            postgres    false    221            �           2606    16565    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    214            �           2606    16566    serwice machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.serwice
    ADD CONSTRAINT machine_fkay FOREIGN KEY (machine) REFERENCES public.machines(machine_id) NOT VALID;
 >   ALTER TABLE ONLY public.serwice DROP CONSTRAINT machine_fkay;
       public          postgres    false    3208    220    218            �           2606    16571    ma_us_ts machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.ma_us_ts
    ADD CONSTRAINT machine_fkay FOREIGN KEY (machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 ?   ALTER TABLE ONLY public.ma_us_ts DROP CONSTRAINT machine_fkay;
       public          postgres    false    217    218    3208            �           2606    16576    ma_us_ts taask_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.ma_us_ts
    ADD CONSTRAINT taask_fkay FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) NOT VALID;
 =   ALTER TABLE ONLY public.ma_us_ts DROP CONSTRAINT taask_fkay;
       public          postgres    false    217    221    3212            �           2606    16581    alerts user_fkay    FK CONSTRAINT     ~   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT user_fkay FOREIGN KEY (who_add) REFERENCES public.users(user_id) NOT VALID;
 :   ALTER TABLE ONLY public.alerts DROP CONSTRAINT user_fkay;
       public          postgres    false    214    216    3202            �           2606    16586    ma_us_ts user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.ma_us_ts
    ADD CONSTRAINT user_fkay FOREIGN KEY (user_id) REFERENCES public.users(user_id) NOT VALID;
 <   ALTER TABLE ONLY public.ma_us_ts DROP CONSTRAINT user_fkay;
       public          postgres    false    214    217    3202            "      x������ � �      #      x������ � �      $   $   x�3�t�s6�,��N,�N�L�.�,�K����� v��      &      x������ � �      '      x������ � �          #  x�MQ�r� <����͗t:ɥ��؋j�C؀&���O���r�j%�
�@˙Dx�de#�)m���9H�;�PH��v(�`w��ezF�[�=,�,����z�=
���3�#�!�R�gif?�q{8&�#����$RM���O��� H�cKC�����a��cD3�����K:,B��t���A�c*��2�AG=�ԩ~pt �<�!}���Z�%���o[��Ǜ;Phďx̫y�J&��~M�WJ�1�}����Ӧ�&<�5+t��r�Y��Zy�����#��'     