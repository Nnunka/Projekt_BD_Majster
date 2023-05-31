PGDMP         	                {           Majster    15.2    15.2 #    2           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            3           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            4           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            5           1262    16518    Majster    DATABASE     |   CREATE DATABASE "Majster" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Polish_Poland.1250';
    DROP DATABASE "Majster";
                Majster    false            �            1259    17501    users    TABLE     �  CREATE TABLE public.users (
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
       public         heap    postgres    false            �            1259    17508    users_user_id_seq    SEQUENCE     z   CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          postgres    false    214            6           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          postgres    false    215            �            1259    17509    alerts    TABLE     �  CREATE TABLE public.alerts (
    alert_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    alert_title character varying(100) NOT NULL,
    alert_who_add_id bigint NOT NULL,
    alert_details character varying(10000) NOT NULL,
    alert_add_date timestamp with time zone NOT NULL,
    alert_exist boolean DEFAULT true NOT NULL,
    alert_machine_id bigint DEFAULT 0
);
    DROP TABLE public.alerts;
       public         heap    postgres    false    215            �            1259    17517    machines    TABLE     
  CREATE TABLE public.machines (
    machine_id bigint NOT NULL,
    machine_name character varying(100) NOT NULL,
    machine_type character varying(100) NOT NULL,
    machine_status character varying(100) NOT NULL,
    machine_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.machines;
       public         heap    postgres    false            �            1259    17521    machines_machine_id_seq    SEQUENCE     �   CREATE SEQUENCE public.machines_machine_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.machines_machine_id_seq;
       public          postgres    false    217            7           0    0    machines_machine_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.machines_machine_id_seq OWNED BY public.machines.machine_id;
          public          postgres    false    218            �            1259    17522    realize_tasks    TABLE     �   CREATE TABLE public.realize_tasks (
    realize_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    realize_user_id bigint NOT NULL,
    realize_machine_id bigint NOT NULL,
    realize_task_id bigint NOT NULL
);
 !   DROP TABLE public.realize_tasks;
       public         heap    postgres    false    215            �            1259    17526    services    TABLE     #  CREATE TABLE public.services (
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
       public         heap    postgres    false    218            �            1259    17535    tasks    TABLE     �  CREATE TABLE public.tasks (
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
       public         heap    postgres    false    218            �           2604    17542    machines machine_id    DEFAULT     z   ALTER TABLE ONLY public.machines ALTER COLUMN machine_id SET DEFAULT nextval('public.machines_machine_id_seq'::regclass);
 B   ALTER TABLE public.machines ALTER COLUMN machine_id DROP DEFAULT;
       public          postgres    false    218    217            z           2604    17543    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    215    214            *          0    17509    alerts 
   TABLE DATA           �   COPY public.alerts (alert_id, alert_title, alert_who_add_id, alert_details, alert_add_date, alert_exist, alert_machine_id) FROM stdin;
    public          postgres    false    216   �-       +          0    17517    machines 
   TABLE DATA           i   COPY public.machines (machine_id, machine_name, machine_type, machine_status, machine_exist) FROM stdin;
    public          postgres    false    217   �.       -          0    17522    realize_tasks 
   TABLE DATA           i   COPY public.realize_tasks (realize_id, realize_user_id, realize_machine_id, realize_task_id) FROM stdin;
    public          postgres    false    219   ]/       .          0    17526    services 
   TABLE DATA           �   COPY public.services (service_id, service_title, service_machine_id, service_details, service_start_date, service_end_date, service_exist, service_status, service_user_id) FROM stdin;
    public          postgres    false    220   �/       /          0    17535    tasks 
   TABLE DATA           �   COPY public.tasks (task_id, task_title, task_details, task_add_date, task_start_date, task_end_date, task_exist, task_start_date_by_user) FROM stdin;
    public          postgres    false    221   �0       (          0    17501    users 
   TABLE DATA              COPY public.users (user_id, user_name, user_surname, user_email, user_login, user_password, user_role, user_exist) FROM stdin;
    public          postgres    false    214   �2       8           0    0    machines_machine_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.machines_machine_id_seq', 85, true);
          public          postgres    false    218            9           0    0    users_user_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.users_user_id_seq', 75, true);
          public          postgres    false    215            �           2606    17545    alerts alerts_pkay 
   CONSTRAINT     V   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkay PRIMARY KEY (alert_id);
 <   ALTER TABLE ONLY public.alerts DROP CONSTRAINT alerts_pkay;
       public            postgres    false    216            �           2606    17547    machines machines_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (machine_id);
 @   ALTER TABLE ONLY public.machines DROP CONSTRAINT machines_pkey;
       public            postgres    false    217            �           2606    17549    realize_tasks mut_pkay 
   CONSTRAINT     \   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT mut_pkay PRIMARY KEY (realize_id);
 @   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT mut_pkay;
       public            postgres    false    219            �           2606    17551    services serwic_pkay 
   CONSTRAINT     Z   ALTER TABLE ONLY public.services
    ADD CONSTRAINT serwic_pkay PRIMARY KEY (service_id);
 >   ALTER TABLE ONLY public.services DROP CONSTRAINT serwic_pkay;
       public            postgres    false    220            �           2606    17553    tasks tasks_pkay 
   CONSTRAINT     S   ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkay PRIMARY KEY (task_id);
 :   ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_pkay;
       public            postgres    false    221            �           2606    17555    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    214            �           2606    17556    services machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT machine_fkay FOREIGN KEY (service_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 ?   ALTER TABLE ONLY public.services DROP CONSTRAINT machine_fkay;
       public          postgres    false    217    3214    220            �           2606    17561    realize_tasks machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT machine_fkay FOREIGN KEY (realize_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 D   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT machine_fkay;
       public          postgres    false    219    3214    217            �           2606    17566    realize_tasks taask_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT taask_fkay FOREIGN KEY (realize_task_id) REFERENCES public.tasks(task_id) NOT VALID;
 B   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT taask_fkay;
       public          postgres    false    3220    221    219            �           2606    17571    alerts user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT user_fkay FOREIGN KEY (alert_who_add_id) REFERENCES public.users(user_id) NOT VALID;
 :   ALTER TABLE ONLY public.alerts DROP CONSTRAINT user_fkay;
       public          postgres    false    214    216    3210            �           2606    17576    realize_tasks user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT user_fkay FOREIGN KEY (realize_user_id) REFERENCES public.users(user_id) NOT VALID;
 A   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT user_fkay;
       public          postgres    false    219    3210    214            *   �   x�]�Kn�0D��)�/"��)ٺE�.�!�p�|`�(�ӗF�� -Fļ2�y��0 ]�=`���ˆ[�6՜(:�ɋg(���m��y$��!���Õ���y*�y��I�ǅ}���2�4��6��<�-�C�Dd�N�ɑ�u��V�^�J�)&	�;׬�P��gԟrD���h��ӈ�zLl �&��g�/g��c���X��-zi�~?�rƽ~���.&��-�`�����f�i_      +   y   x�34���L75s�.H,O,�N�t��L�I�L�2�t�s6�,�����gs�p�sz$e楗��ś�q�W u��%��%��V�MLW�L�,���PztOerf)PM� J	(�      -   "   x�37�4�4�43�27�4�42�4������ 2��      .   E  x�}�Mj1�ךSx_bd�7>G��nL<!%���,{�ޫ�d�q)��󓴃<�ØP�筀��톼@�s� ��zܠ�Z��&�s:��=`gt�:������3�P>Z���u;D�Q��f��p:�c�ӆ]���WZ(�0��(40c��Tr��+)�1����0D����YkZC-A.b��z?����h�8�B�H5
i5�@�x�%���B`6Iԡ�k5�`]W�w+P������ƹ�5"�֛�0����x�+�"l�ji�<�����$����W^�S9�S�/�!�^�������D��N"}��I�\�G�J�ЬD߆�.����Mɑ      /   �  x��T�n�0���^��HQ����%��챁�~)�FbY-:4"��g�H�`�x���8��j�������QΔN6d��"p�$cS�3Z�b����'��0,�i5�a<ٔ9f�$�#����(k���V�X`��r9�A��K4s{��c����Ō5�mk�YC����Z�A*
gV�IA�F*�T�h��G�����<$�6���EJl� �t �9A�N�A�0����P׾�H�.�s�eV(f�1v!b���s������2�֔D
�M����D��``���	*
�:@C3_�yy��g3�~<�gߋ/S^֚h���$e�ؓ��J�Nkjϰ���T�� -�K2�K��i/�F���!�I@�o����К��B8!Rey�u. W�ƅv������
��V됣���>�J��̞�������n��k�v!�Em�wD����i��jAL���z)���_0�7��HE      (   '  x�mQKN�0];����]7H6H3K6�&@��5iTM��}��U�E�g���IZxE/�Bx�t��v�4F�����Tr��3*8L�z�pFU���7ws�f
sK&�D��%��%���r�N��,�8>��$��\4��97��� .�M$GP���e�M�w0h���*y�>�Vº�>�L&�m7ΖŎ�sj�Vj�`DG!lQ(�\AՈP�-V��V�6�?��ʿ�Z��ſ�n������%Jn{�w��R.�u�J����na	�R��Ň�4����Ʒ�����D     